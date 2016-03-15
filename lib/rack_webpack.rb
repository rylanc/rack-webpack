module RackWebpack
  class Error < StandardError; end

  Configuration = Struct.new(
    :host,
    :port,
    :webpack_server_options,
    :proxy,
    :asset_regex,
    :disable_runner
  )

  class << self
    attr_accessor :curb_available

    def config
      # Host and Port defaults
      @config ||= Configuration.new('localhost', '8080')
    end

    def configure
      yield(config)
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
require 'rack_webpack/railtie' if defined?(Rails)
