require 'rack/server'


class Rack::Server
  def start_with_webpack
    RackWebpack::WebpackRunner.run unless RackWebpack.config.disable_runner
    start_without_webpack
  end
  alias_method :start_without_webpack, :start
  alias_method :start, :start_with_webpack
end

at_exit do
  RackWebpack::WebpackRunner.exit unless RackWebpack.config.disable_runner
end
