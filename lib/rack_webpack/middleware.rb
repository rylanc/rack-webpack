module RackWebpack
  class Middleware
    def initialize(app)
      @app = app

    end

    def call(env)
      path = env['REQUEST_PATH']
      
      if path =~ /\.bundle\.js/
        info "Proxying #{path}"

        begin
          resp = get( path )
        rescue Errno::ECONNREFUSED
          info 'Error reading from webpack-dev-server UNIX socket. It must have crashed.'
          WebpackRunner.restart
          sleep 5
          resp = get( path )
        end
                
        [resp.code, resp.to_hash, [resp.body]]
      else
        @app.call(env)
      end
    end
    
    private
    
    def get( path )
      http = SocketHttp.new( WebpackRunner.socket_path )
      request = Net::HTTP::Get.new( path )
      http.request( request )      
    end
    
    def logger
      @logger ||= defined?(Rails) ? Rails.logger : Logger.new(STDOUT)
    end
    
    def info( msg )
      logger.info "[RackWebpack::Middleware] #{msg}"
    end
  end
end
