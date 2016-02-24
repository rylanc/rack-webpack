module RackWebpack
  module Middleware
    class NetHttpProxy < Base

      protected
      
      def proxy( path )
        begin
          resp = get( path )
        rescue Errno::ECONNREFUSED
          info 'Error reading from webpack-dev-server UNIX socket. It must have crashed.'
          restart
        end
              
        [resp.code, resp.to_hash, [resp.body]]
      end
    
      def get( path )
        http = SocketHttp.new( WebpackRunner.socket_path )
        request = Net::HTTP::Get.new( path )
        http.request( request )      
      end
    
    end
  end
end
