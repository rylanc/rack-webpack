module RackWebpack
  module Middleware

    class Base
  
      def initialize(app)
        @app = app
        info "Loaded #{self.class.to_s}"
      end

      def call(env)
        path = env['REQUEST_PATH']
    
        if path =~ /\.bundle\.js/
          info "Proxying #{path}"

          proxy( path )
        else
          @app.call(env)
        end
      end
  
      protected

      def logger
        @logger ||= defined?(Rails) ? Rails.logger : Logger.new(STDOUT)
      end

      def info( msg )
        logger.info "[RackWebpack::Middleware] #{msg}"
      end
  
      def restart
        info 'Error reading from webpack-dev-server UNIX socket. It must have crashed.'
        WebpackRunner.restart
        sleep 2
      end
  
    end
  end
end