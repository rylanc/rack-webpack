require 'fileutils'

class RackWebpack::FileMutex

  class << self
    attr_writer :locks_dir


    # Path to directory containing PID lock files.
    def locks_dir
      @locks_dir || _default_locks_dir
    end


    # Default value for directory containing PID lock files.
    def _default_locks_dir
      defined?(Rails) ? Rails.root.join('tmp/pids') : Pathname.new('tmp/pids')
    end
  end


  # name - Mutex name, will determine the filename of the PID lock file.
  def initialize(name)
    @name = name
  end


  # Path to the PID lock file backing this FileMutex instance.
  def lock_file_path
    File.join(self.class.locks_dir, "#{@name}.lock")
  end


  # Attempt to acquire the mutex by obtaining a filesystem lock on the PID file.
  def acquire
    # Ensure the locks_dir directory exists
    FileUtils.mkdir_p(self.class.locks_dir)

    # Open PID file and attempt to obtain a filesystem lock (non-blocking)
    @lock_file ||= File.open(lock_file_path, File::RDWR|File::CREAT, 0644)
    acquired = !! @lock_file.flock(File::LOCK_EX|File::LOCK_NB)

    close_file unless acquired
    acquired
  end


  # Write the current process id to the PID file. Will fail if this instance is
  # not currently the mutex owner (and is unable to acquire the mutex).
  def set( pid )
    raise( RackWebpack::Error,
           'Must acquire lock before setting PID' ) unless acquire
    @lock_file.truncate(0)
    @lock_file.rewind
    @lock_file.puts pid
    @lock_file.flush
    pid
  end


  # Get the current value of the PID file. This instance does not need to be
  # the mutex owner.
  def get
    content =
      if @lock_file
        @lock_file.rewind
        @lock_file.read
      else
        File.read(lock_file_path) if File.exist?(lock_file_path)
      end
    if content
      content.strip!
      content == '' ? nil : content.to_i
    end
  end


  # Release the filesystem lock on the PID file and delete it.
  def release
    return unless @lock_file # Skip if we don't have a file

    @lock_file.flock(File::LOCK_UN)
    File.delete( @lock_file )
    close_file
  end


  private


  # Close and unset the lock file.
  def close_file
    @lock_file.close
    @lock_file = nil
  end

end
