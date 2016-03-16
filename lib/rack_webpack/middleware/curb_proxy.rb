require 'curl'

module RackWebpack
  module Middleware
    class CurbProxy < Base
    
      protected

      def fetch( path )
        curl.url = "http://localhost#{path}"
        curl.perform
        [status_code, headers, [curl.body]]
      end

      def connection_error_clazz
        Curl::Err::ConnectionFailedError
      end

      def curl
        @curl ||= Curl::Easy.new.tap do |c|
          c.set(:unix_socket_path, WebpackRunner.socket_path)
        end
      end

      def status_code
        curl.status.split(' ').first.to_i
      end

      def headers
        header_lines = curl.header_str.strip.lines[1..-1]
        headers = header_lines.map{|h| s = h.split(':'); s.map(&:strip)}
        Hash[*headers.flatten]
      end

    end
  end
end
