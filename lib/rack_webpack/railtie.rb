module RackWebpack
  class Railtie < Rails::Railtie
    initializer "rack_webpack.insert_middleware" do |app|
      if Rails.env.in?(%w(development test))
        app.config.middleware.insert_before 0, 'RackWebpack::Middleware'
      end
    end
  end
end
