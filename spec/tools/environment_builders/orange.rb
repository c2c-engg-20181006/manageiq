require 'fog/orange'

$LOAD_PATH.push(Rails.root.to_s)
require_relative 'orange/interaction_methods'
require_relative 'orange/helper_methods'
include Orange::InteractionMethods
include Orange::HelperMethods

require "#{test_base_dir}/refresh_spec_environments"
include Orange::RefreshSpecEnvironments

require_relative 'orange/services/identity/builder'
require_relative 'orange/services/network/builder'
require_relative 'orange/services/compute/builder'
require_relative 'orange/services/volume/builder'
require_relative 'orange/services/image/builder'
require_relative 'orange/services/orchestration/builder'
require_relative 'orange/services/storage/builder'

def usage(s)
  $stderr.puts(s)
  $stderr.puts("Run on a VM with at least 8GB of RAM!!!")
  $stderr.puts("Usage: bundle exec rails r spec/tools/environment_builders/orange.rb")
  $stderr.puts("Will run env. builder for environments specified in environments.yaml, unless you specify only one of")
  $stderr.puts("them with  --only-environment")
  $stderr.puts("Options:")
  $stderr.puts("         [--only-environment <name>]  - allowed values #{allowed_environments}")
  exit(2)
end

unless File.exist?(orange_environment_file)
  raise ArgumentError, usage("expecting #{orange_environment_file}")
end

@only_environment = nil

loop do
  option = ARGV.shift
  case option
    when '--only-environment', '-o'
      argv      = ARGV.shift
      supported = allowed_environments
      raise ArgumentError, usage("supported --identity options are #{supported}") unless supported.include?(argv.to_sym)
      @only_environment = argv.to_sym
    when /^-/
      usage("Unknown option: #{option}")
    else
      break
  end
end

orange_environments.each do |env|
  env_name = env.keys.first
  env      = env[env_name]

  @environment = env_name.to_sym
  # TODO(lsmola) make it possible to not to store the ems in db
  create_or_update_ems(env_name, env["ip"], env["password"], 5000, env["user"], identity_service.to_s)

  unless @only_environment.blank?
    next unless @environment == @only_environment
  end

  $fog_log.level = 0
  puts "---------------------------------------------------------------------------------------------------------------"
  puts "Building VCR  Environment for environment '#{@environment}'. Used services are, networking: "\
       "'#{networking_service}' and identity: '#{identity_service}'..."
  puts "---------------------------------------------------------------------------------------------------------------"

  # TODO: Create a domain to contain refresh-related objects (Havana and above)
  identity = Orange::Services::Identity::Builder.build_all(@ems, identity_service)
  # TODO(lsmola) cycle through many projects, so we test also multitenancy
  project = identity.projects.detect { |x| x.name == "EmsRefreshSpec-Project" }

  network = Orange::Services::Network::Builder.build_all(@ems, project, networking_service)
  compute = Orange::Services::Compute::Builder.build_all(@ems, project)
  image   = Orange::Services::Image::Builder.build_all(@ems, project)
  volume  = Orange::Services::Volume::Builder.build_all(@ems, project, @environment, image)

  if storage_supported?
    Orange::Services::Storage::Builder.build_all(@ems, project)
  end

  if orchestration_supported?
    Orange::Services::Orchestration::Builder.build_all(@ems, project, network)
  end
  #
  # Create all servers
  #
  compute.build_servers(volume, network, image, networking_service)

  #
  # Set states of the servers
  #
  compute.do_action(compute.servers.detect { |x| x.name == "EmsRefreshSpec-Paused" }, :pause)
  compute.do_action(compute.servers.detect { |x| x.name == "EmsRefreshSpec-Suspended" }, :suspend)
  compute.do_action(compute.servers.detect { |x| x.name == "EmsRefreshSpec-Shelved" }, :shelve)

  puts "Finished"
end
