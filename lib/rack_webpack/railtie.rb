module RackWebpack
  class Railtie < Rails::Railtie
    initializer "rack_webpack.insert_middleware" do |app|
      app.config.middleware.use "RackWebpack::Middleware"
    end
  end
end