require 'rack/server'


class Rack::Server
  def start_with_webpack
    RackWebpack::WebpackRunner.run unless RackWebpack.config.disable
    start_without_webpack
  end
  alias_method_chain :start, :webpack
end

at_exit do
  RackWebpack::WebpackRunner.exit unless RackWebpack.config.disable
end
