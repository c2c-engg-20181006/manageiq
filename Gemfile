raise "Ruby versions less than 2.3.1 are unsupported!" if RUBY_VERSION < "2.3.1"

source 'https://rubygems.org'

plugin "bundler-inject", "~> 1.1"
require File.join(Bundler::Plugin.index.load_paths("bundler-inject")[0], "bundler-inject") rescue nil

#
# VMDB specific gems
#

gem "manageiq-gems-pending", ">0", :require => 'manageiq-gems-pending', :git => "https://github.com/ManageIQ/manageiq-gems-pending.git", :ref => "c84fb5826484"
# Modified gems for gems-pending.  Setting sources here since they are git references
gem "handsoap", "~>0.2.5", :require => false, :git => "https://github.com/ManageIQ/handsoap.git", :tag => "v0.2.5-5"

# when using this Gemfile inside a providers Gemfile, the dependency for the provider is already declared
def manageiq_plugin(plugin_name)
  unless dependencies.detect { |d| d.name == plugin_name }
    gem plugin_name, :git => "https://github.com/ManageIQ/#{plugin_name}", :branch => "master"
  end
end

def manageiq_plugin_with_commit_id(plugin_name, commit_id)
  unless dependencies.detect { |d| d.name == plugin_name }
    gem plugin_name, :git => "https://github.com/ManageIQ/#{plugin_name}", :ref => commit_id
  end
end

def c2c_manageiq_plugin(plugin_name, branch_name)
  unless dependencies.detect { |d| d.name == plugin_name }
    gem plugin_name, :git => "https://github.com/Click2Cloud/#{plugin_name}", :branch => branch_name
  end
end

manageiq_plugin_with_commit_id "manageiq-providers-ansible_tower", "88aa135"
c2c_manageiq_plugin "manageiq-schema", "dev"

# Unmodified gems
gem "activerecord-virtual_attributes", "~>1.0.0"
gem "activerecord-id_regions",        "~>0.2.0"
gem "activerecord-session_store",     "~>1.1"
gem "acts_as_tree",                   "~>2.7" # acts_as_tree needs to be required so that it loads before ancestry
gem "ancestry",                       "~>3.0.4",       :require => false
gem "bcrypt",                         "~> 3.1.10",     :require => false
gem "bundler",                        ">=1.15",        :require => false
gem "byebug",                                          :require => false
gem "color",                          "~>1.8"
gem "config",                         "~>1.6.0",       :require => false
gem "dalli",                          "=2.7.6",        :require => false
gem "default_value_for",              "~>3.0.3"
gem "docker-api",                     "~>1.33.6",      :require => false
gem "elif",                           "=0.1.0",        :require => false
gem "fast_gettext",                   "~>1.2.0"
gem "gettext_i18n_rails",             "~>1.7.2"
gem "gettext_i18n_rails_js",          "~>1.3.0"
gem "hamlit",                         "~>2.8.5"
gem "highline",                       "~>1.6.21",      :require => false
gem "inifile",                        "~>3.0",         :require => false
gem "inventory_refresh",              "~>0.1.2",       :require => false
gem "kubeclient",                     "~>4.0",         :require => false # For scaling pods at runtime
gem "linux_admin",                    "~>1.2.1",       :require => false
gem "log_decorator",                  "~>0.1",         :require => false
gem "manageiq-api-client",            "~>0.3.3",       :require => false
gem "manageiq-messaging",                              :require => false, :git => "https://github.com/ManageIQ/manageiq-messaging", :ref => "07b4e6c6f8ca"
gem "manageiq-password",              "~>0.3",         :require => false
gem "manageiq-postgres_ha_admin",     "~>3.0",         :require => false
gem "memoist",                        "~>0.15.0",      :require => false
gem "mime-types",                     "~>3.0",         :path => File.expand_path("mime-types-redirector", __dir__)
gem "more_core_extensions",           "~>3.5"
gem "nakayoshi_fork",                 "~>0.0.3"  # provides a more CoW friendly fork (GC a few times before fork)
gem "net-ldap",                       "~>0.16.1",      :require => false
gem "net-ping",                       "~>1.7.4",       :require => false
gem "openscap",                       "~>0.4.8",       :require => false
gem "optimist",                       "~>3.0",         :require => false
gem "pg",                                              :require => false
gem "pg-dsn_parser",                  "~>0.1.0",       :require => false
gem "query_relation",                 "~>0.1.0",       :require => false
gem "rails",                          "~>5.0.7.2"
gem "rails-i18n",                     "~>5.x"
gem "rake",                           ">=11.0",        :require => false
gem "rest-client",                    "~>2.0.0",       :require => false
gem "ripper_ruby_parser",             "~>1.5.1",       :require => false
gem "ruby-progressbar",               "~>1.7.0",       :require => false
gem "rubyzip",                        "~>1.2.2",       :require => false
gem "rugged",                         "~>0.27.0",      :require => false
gem "snmp",                           "~>1.2.0",       :require => false
gem "sprockets",                      "~>3.0",         :require => false
gem "sqlite3",                        "~>1.3.0",       :require => false

# Modified gems (forked on Github)
gem "ruport",                         "=1.7.0",                       :git => "https://github.com/ManageIQ/ruport.git", :tag => "v1.7.0-3"

# In 1.9.3: Time.parse uses british version dd/mm/yyyy instead of american version mm/dd/yyyy
# american_date fixes this to be compatible with 1.8.7 until all callers can be converted to the 1.9.3 format prior to parsing.
# See miq_expression_spec Date/Time Support examples.
# https://github.com/jeremyevans/ruby-american_date
gem "american_date"

# Make sure to tag your new bundler group with the manageiq_default group in addition to your specific bundler group name.
# This default is used to automatically require all of our gems in processes that don't specify which bundler groups they want.
#
### providers
c2c_manageiq_plugin "manageiq-providers-telefonica", "dev"
c2c_manageiq_plugin "manageiq-providers-orange", "dev"
c2c_manageiq_plugin "manageiq-providers-huawei", "master"
c2c_manageiq_plugin "manageiq-providers-alibaba", "master"
c2c_manageiq_plugin "manageiq-providers-otc", "master"

group :openstack, :manageiq_default do
  manageiq_plugin_with_commit_id "manageiq-providers-openstack", "1a8bc1a67903"
end

group :amazon, :manageiq_default do
  manageiq_plugin_with_commit_id "manageiq-providers-amazon", "caaa4e5eed89"
  gem "amazon_ssa_support",                          :require => false, :git => "https://github.com/ManageIQ/amazon_ssa_support.git", :ref => "8691fb85780f" # Temporary dependency to be moved to manageiq-providers-amazon when officially release
end

group :azure, :manageiq_default do
  manageiq_plugin_with_commit_id "manageiq-providers-azure", "3eca30ccf94e"
end

group :foreman, :manageiq_default do
  manageiq_plugin_with_commit_id "manageiq-providers-foreman", "9bb740a262a2"
  gem "foreman_api_client",             ">=0.1.0",   :require => false, :git => "https://github.com/ManageIQ/foreman_api_client.git", :ref => "1cdf102c9331"
end

group :google, :manageiq_default do
  manageiq_plugin_with_commit_id "manageiq-providers-google", "866d9d5e2a85"
end

group :kubernetes, :openshift, :manageiq_default do
  manageiq_plugin_with_commit_id "manageiq-providers-kubernetes", "e1cf8efbf77b"
end

group :kubevirt, :manageiq_default do
  manageiq_plugin_with_commit_id "manageiq-providers-kubevirt", "e8b476921e0d"
end

group :lenovo, :manageiq_default do
  manageiq_plugin_with_commit_id "manageiq-providers-lenovo", "e187a2f37b8e"
end

group :nuage, :manageiq_default do
  manageiq_plugin_with_commit_id "manageiq-providers-nuage", "e340112ac958"
end

group :redfish, :manageiq_default do
  manageiq_plugin_with_commit_id "manageiq-providers-redfish", "a3d624439b1b"
end

group :qpid_proton, :optional => true do
  gem "qpid_proton",                    "~>0.26.0",      :require => false
end

group :openshift, :manageiq_default do
  manageiq_plugin_with_commit_id "manageiq-providers-openshift", "4bd6ad56b9bc"
end

group :ovirt, :manageiq_default do
  manageiq_plugin_with_commit_id "manageiq-providers-ovirt", "c41774be66dc"
  gem "ovirt_metrics",                  "~>2.0.0",       :require => false
end

group :scvmm, :manageiq_default do
  manageiq_plugin_with_commit_id "manageiq-providers-scvmm", "1c396537bb6f"
end

group :vmware, :manageiq_default do
  manageiq_plugin_with_commit_id "manageiq-providers-vmware", "af70b995c328"
  gem "vmware_web_service",             "~>0.4.0"
end

### shared dependencies
group :google, :openshift, :manageiq_default do
  gem "sshkey",                         "~>1.8.0",       :require => false
end

### end of provider bundler groups

group :automate, :seed, :manageiq_default do
  manageiq_plugin_with_commit_id "manageiq-automation_engine", "ff0f0dd935cc"
end

group :replication, :manageiq_default do
  gem "pg-pglogical",                   "~>2.1.2",       :require => false
end

group :rest_api, :manageiq_default do
  manageiq_plugin_with_commit_id "manageiq-api", "f2d81916c240"
end

group :graphql_api, :manageiq_default do
  manageiq_plugin_with_commit_id "manageiq-graphql", "b5602ca62a42"
end

group :scheduler, :manageiq_default do
  # Modified gems (forked on Github)
  gem "rufus-scheduler", "=3.1.10.2", :git => "https://github.com/ManageIQ/rufus-scheduler.git", :require => false, :tag => "v3.1.10-2"
end

group :seed, :manageiq_default do
  manageiq_plugin_with_commit_id "manageiq-content", "2c6c747a81a1"
end

group :smartstate, :manageiq_default do
  gem "manageiq-smartstate",            "~>0.2.19",       :require => false
end

group :consumption, :manageiq_default do
  manageiq_plugin_with_commit_id "manageiq-consumption", "82739b155d70"
  gem 'hashdiff'
end

group :ui_dependencies do # Added to Bundler.require in config/application.rb
  c2c_manageiq_plugin "manageiq-decorators", "dev-OTHAO"
  c2c_manageiq_plugin "manageiq-ui-classic", "dev-OTHAO"
  # Modified gems (forked on Github)
  gem "jquery-rjs",                   "=0.1.1",                       :git => "https://github.com/ManageIQ/jquery-rjs.git", :tag => "v0.1.1-1"
end

group :v2v, :ui_dependencies do
  manageiq_plugin_with_commit_id "manageiq-v2v", "6e8a5685c5e7"
end

group :web_server, :manageiq_default do
  gem "puma",                           "~>3.7.0"
  gem "responders",                     "~>2.0"
  gem "ruby-dbus" # For external auth
  gem "secure_headers",                 "~>3.0.0"
end

group :web_socket, :manageiq_default do
  gem "surro-gate",                     "~>1.0.5", :require => false
  gem "websocket-driver",               "~>0.6.3", :require => false
end

### Start of gems excluded from the appliances.
# The gems listed below do not need to be packaged until we find it necessary or useful.
# Only add gems here that we do not need on an appliance.
#
unless ENV["APPLIANCE"]
  group :development do
    gem "foreman"
    gem "haml_lint",        "~>0.20.0", :require => false
    gem "rubocop",          "~>0.52.1", :require => false
    # ruby_parser is required for i18n string extraction
    gem "ruby_parser",                  :require => false
    gem "scss_lint",        "~>0.48.0", :require => false
    gem "yard"
  end

  group :test do
    gem "brakeman",         "~>3.3",    :require => false
    gem "capybara",         "~>2.5.0",  :require => false
    gem "coveralls",                    :require => false
    gem "factory_bot",      "~>4.11.1", :require => false
    gem "timecop",          "~>0.7.3",  :require => false
    gem "vcr",              "~>3.0.2",  :require => false
    gem "webmock",          "~>2.3.1",  :require => false
  end

  group :development, :test do
    gem "parallel_tests"
    gem "rspec-rails",      "~>3.6.0"
  end
end
gem "fog-aliyun",:require => false, :git => "https://github.com/Click2Cloud/fog-aliyun.git", :branch => "master"