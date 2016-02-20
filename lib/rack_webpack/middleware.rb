module RackWebpack
  class Middleware
    def initialize(app)
      @app = app

    end

    def call(env)
      path = env['REQUEST_PATH']
      
      if path =~ /\.bundle\.js/
        Kernel.warn 'JDS Request To Proxy'

        begin
          resp = get( path )
        rescue Errno::ECONNREFUSED
          WebpackRunner.restart
          sleep 5
          resp = get( path )
        end
                
        [resp.code, resp.to_hash, [resp.body]]
      else
        @app.call(env)
      end
    end
    
    def get( path )
      http = SocketHttp.new( WebpackRunner.socket_path )
      request = Net::HTTP::Get.new( path )
      http.request( request )      
    end
  end
end
