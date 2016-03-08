module RackWebpack
  Configuration = Struct.new(
    :webpack_options,
    :proxy_condition,
    :disable
  )
  class << self
    attr_accessor :curb_available

    def config
      @config ||= Configuration.new
    end

    def configure
      yield(config)
      require 'rack_webpack/railtie' if defined?(Rails)
    end
  end
end

begin
  require 'curl'
  RackWebpack.curb_available = Curl.const_defined?('CURLOPT_UNIX_SOCKET_PATH')
rescue LoadError
  RackWebpack.curb_available = false
end

require 'rack_webpack/version'
require 'rack_webpack/file_mutex'
require 'rack_webpack/socket_http'

require 'rack_webpack/webpack_runner'
require 'rack_webpack/middleware'
require 'rack_webpack/hooks'
