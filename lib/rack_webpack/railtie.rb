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

    config.action_controller.asset_host = -> (source) do
      if source =~ RackWebpack.config.asset_regex
        RackWebpack::WebpackRunner.webpack_host
      end
    end

    rake_tasks do
      load 'rack_webpack/tasks/assets.rake'
    end

  end
end
