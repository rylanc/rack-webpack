require_relative 'file_mutex'

module RackWebpack
  class WebpackRunner
    class << self
      def socket_path
        'tmp/test_socket'
      end
      
      def webpack_cmd
        'node_modules/webpack-dev-server/bin/webpack-dev-server.js'
      end
      
      def mutex
        @mutex ||= FileMutex.new('webpack-server')
      end

      def run
        @run_count ||= 0
        return if @run_count > 0 && mutex.get
      
        if mutex.acquire
          log "Lock acquired on PID file #{mutex.lock_file_path}"

          check_existing_pid

          log 'Starting Webpack...'
          delete_socket
          pid = Process.spawn "#{webpack_cmd} --port #{socket_path}", pgroup: true, out: $stdout, err: $stderr
          mutex.set( pid )
          log "Webpack started with PID #{pid}"

        else
          log "PID file #{mutex.lock_file_path} is already locked."
          log 'Webpack should be running. Otherwise try deleting the PID file and restarting.'
        end
        
        @run_count += 1
      end

      def shutdown( pid = nil )
        mutex_pid = mutex.get
        pid ||= mutex_pid
        
        return unless pid && mutex.acquire
        
        begin
          log "Sending SIGINT to pgroup #{pid}"
          Process.kill '-INT', pid
        rescue Errno::ESRCH, Errno::EPERM
          log "pgroup #{pid} does not exist"
        end

        begin
          Process.wait( pid )
          log "Process #{pid} has terminated"
        rescue Errno::ECHILD; end

        mutex.set( nil ) if pid == mutex_pid
        delete_socket
      end
      
      def exit
        shutdown
        mutex.release
      end
      
      def restart
        log 'Restarting Webpack. It must have crashed.'
        shutdown
        run
      end
      
      def check_existing_pid
        existing_pid = mutex.get
        if existing_pid
          log "Found existing PID #{existing_pid} in PID file"
          shutdown existing_pid
        end
      end

      def delete_socket
        File.delete( socket_path ) if File.exists?( socket_path )
      end

      def log( msg )
        Kernel.warn "[WebpackRunner] #{msg}"
      end
    end
  end
end

