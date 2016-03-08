module RackWebpack
  class Railtie < Rails::Railtie
    initializer :rack_webpack, after: :load_config_initializers do |app|
      if Rails.env.in?(%w(development test)) && !RackWebpack.config.disable
        proxy = ENV['RACK_WEBPACK_PROXY']

        if proxy.blank?
          default_proxy = RackWebpack.curb_available ? 'Curb' : 'NetHttp'
          proxy ||= "RackWebpack::Middleware::#{default_proxy}Proxy"
        end

        app.config.middleware.insert_before 0, proxy
      end
    end
  end
end
