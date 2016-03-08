require 'spec_helper'

describe RackWebpack::FileMutex do
  describe '._default_locks_dir' do
    subject { RackWebpack::FileMutex._default_locks_dir }

    it { is_expected.to be_a(Pathname) }
  end

  describe '.new' do
    subject { RackWebpack::FileMutex.new('webpack-test') }

    it 'creates the directory if it does not exist' do
      expect(FileUtils).to receive(:mkdir_p).with(RackWebpack::FileMutex.locks_dir) { true }
      subject
    end
  end
end
