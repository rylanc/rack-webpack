require 'curl'

module RackWebpack
  module Middleware
    class CurbProxy < Base
    
      protected

      def proxy( path )
        curl.url = "http://localhost#{path}"

        begin
          curl.perform
        rescue Curl::Err::ConnectionFailedError
          restart
          curl.perform
        end

        [status_code, headers, [curl.body]]
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