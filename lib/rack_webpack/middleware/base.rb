module RackWebpack
  module Middleware

    class Base

      def initialize(app)
        @app = app
        warn "Loaded #{self.class.to_s}"
      end

      def call(env)
        path = env['REQUEST_PATH']

        if RackWebpack.config.proxy_condition.call(path)
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

    end
  end
end
