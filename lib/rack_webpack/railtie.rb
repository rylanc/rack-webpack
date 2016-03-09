module RackWebpack
  class Railtie < Rails::Railtie

    initializer :rack_webpack, after: :load_config_initializers do |app|
      if Rails.env.in?(%w(development test)) && !RackWebpack.config.disable_runner
        if RackWebpack.config.proxy == :unix_socket
          default_proxy = RackWebpack.curb_available ? 'Curb' : 'NetHttp'
          proxy ||= "RackWebpack::Middleware::#{default_proxy}Proxy"
          app.config.middleware.insert_before 0, proxy
        end
      end
    end

  end
end
