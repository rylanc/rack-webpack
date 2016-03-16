module RackWebpack
  module Middleware
    class NetHttpProxy < Base

      def initialize( app )
        super
        warn 'For better Webpack proxy performance install curb gem >= 0.9.0'
      end
      
      protected

      def fetch( path )
        http    = SocketHttp.new( WebpackRunner.socket_path )
        request = Net::HTTP::Get.new( path )
        resp    = http.request( request )

        [resp.code, resp.to_hash, [resp.body]]
      end

      def connection_error_clazz
        Errno::ECONNREFUSED
      end
    
    end
  end
end
