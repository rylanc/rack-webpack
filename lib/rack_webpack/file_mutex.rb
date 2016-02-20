require 'fileutils'

class RackWebpack::FileMutex
  def self.locks_dir
    @locks_dir || _default_locks_dir
  end

  def self._default_locks_dir
    defined?(Rails) ? Rails.root.join('tmp/pids') : 'tmp/pids'
  end

  def self.locks_dir=(value)
    @locks_dir = value
  end

  def initialize(name)
    @name = name
  end

  def lock_file_path
    File.join(self.class.locks_dir, "#{@name}.lock")
  end

  def acquire
    @lock_file ||= File.open(lock_file_path, File::RDWR|File::CREAT, 0644)
    acquired = !! @lock_file.flock(File::LOCK_EX|File::LOCK_NB)

    close_file unless acquired
    acquired
  end

  def set( pid )
    raise 'Must acquire lock before setting PID' unless acquire
    @lock_file.truncate(0)
    @lock_file.rewind
    @lock_file.puts pid
    @lock_file.flush
    pid
  end

  def get
    content =
      if @lock_file
        @lock_file.rewind
        @lock_file.read
      else
        File.read(lock_file_path) if File.exists?(lock_file_path)
      end
    if content
      content.strip!
      content == '' ? nil : content.to_i
    end
  end

  def release
    return unless @lock_file # Skip if we don't have a file

    @lock_file.flock(File::LOCK_UN)
    File.delete( @lock_file )
    close_file
  end

  private


  def close_file
    @lock_file.close
    @lock_file = nil
  end

end
