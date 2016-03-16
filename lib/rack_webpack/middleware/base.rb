module RackWebpack
  module Middleware

    class Base

      def initialize(app)
        @app = app
        warn "Loaded #{self.class}"
      end

      def call(env)
        path = env['REQUEST_PATH']

        if path =~ RackWebpack.config.asset_regex
          info "Proxying #{path}"

          proxy( path )
        else
          @app.call(env)
        end
      end

      protected

      def proxy( path )
        failed_attempts = 0

        begin
          fetch( path )
        rescue connection_error_clazz
          info 'Error reading from webpack-dev-server socket. It must have crashed.'

          if (failed_attempts += 1) < 3
            restart # Restart Webpack server
            retry   # Retry fetch
          end
        end
      end

      def fetch( path )
        not_implemented 'fetch( path )'
      end

      def connection_error_clazz
        not_implemented 'connection_error_clazz'
      end

      def logger
        @logger ||= defined?(Rails) ? Rails.logger : Logger.new(STDOUT)
      end

      def format_log( msg )
        "[RackWebpack::Middleware] #{msg}"
      end

      def log( sev, msg )
        logger.log sev, format_log( msg )
      end

      def warn( msg )
        log Logger::WARN, msg
        Kernel.warn format_log( msg )
      end

      def info( msg )
        log Logger::INFO, msg
      end

      def restart
        warn 'Error reading from webpack-dev-server UNIX socket. It must have crashed.'
        WebpackRunner.restart
        sleep 2
      end

      def not_implemented( method )
        name = self.class.to_s
        raise Error, "Webpack middleware class #{name} must implement #{method}"
      end

    end
  end
end
