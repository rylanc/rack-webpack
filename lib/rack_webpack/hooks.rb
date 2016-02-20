require 'rack/server'

class Rack::Server
  def start_with_webpack
    RackWebpack::WebpackRunner.run
    start_without_webpack

  end

  alias_method_chain :start, :webpack
end