module RackWebpack
  class Railtie < Rails::Railtie
    initializer "rack_webpack.insert_middleware" do |app|
      if Rails.env.in?(%w(development test))
        proxy = ENV['RACK_WEBPACK_PROXY'] || 'RackWebpack::Middleware::CurbProxy'
        app.config.middleware.insert_before 0, proxy
      end
    end
  end
end
