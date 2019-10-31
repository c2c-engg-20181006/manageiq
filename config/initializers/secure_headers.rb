if defined?(SecureHeaders)
  default_data = ["'self'",'data:',"'unsafe-inline'","'unsafe-eval'",'https://i1379.photobucket.com','https://app.powerbi.com','https://cdnjs.cloudflare.com','https://fonts.googleapis.com','https://ajax.googleapis.com','https://yt3.ggpht.com','https://cors-anywhere.herokuapp.com','https://cloudpricingcalculator.appspot.com','https://cdn3.devexpress.com','https://stackpath.bootstrapcdn.com','https://maxcdn.bootstrapcdn.com','https://cdn.lo4d.com','https://cdn.iconscout.com','https://ga0.imgix.net','https://encrypted-tbn0.gstatic.com','https://code.angularjs.org','https://kendo.cdn.telerik.com','https://fonts.gstatic.com','https://translate.google.com','https://rawgit.com','https://ajax.aspnetcdn.com','https://translate.googleapis.com','https://www.gstatic.com','https://cdn.rawgit.com','http://netdna.bootstrapcdn.com','http://angular-ui.github.io','https://www.w3schools.com','http://i.imgur.com','https://cdn.jsdelivr.net','https://use.fontawesome.com']
  ENV.each do |k, v|
    if k.start_with? 'CB_CSP_'
      unless default_data.include? v
        default_data.push v
      end
    end
  end
  default_data.push ENV['CB_SERVICE']

  default_src_img_data = default_data.clone
  default_src_img_data.push('data:')
  style_src_data = default_data.clone
  style_src_data.push("'unsafe-inline'")
  script_src_data = style_src_data.clone
  script_src_data.push("'unsafe-eval'")

  SecureHeaders::Configuration.default do |config|
    config.hsts = "max-age=#{20.years.to_i}"
    config.x_frame_options = 'SAMEORIGIN'
    config.x_content_type_options = "nosniff"
    config.x_xss_protection = "1; mode=block"
    config.csp = {
      :report_only => false,
      :default_src  => default_src_img_data,
      :frame_src    => default_data,
      :connect_src  => default_data,
      :style_src    => style_src_data,
      :script_src   => script_src_data,
      :img_src      => default_src_img_data,
      :report_uri  => ["/dashboard/csp_report"]
    }
  end
end
