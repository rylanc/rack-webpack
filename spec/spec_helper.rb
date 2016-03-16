$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

Bundler.setup(:default, :development, :test)

if (ENV['CODECLIMATE_REPO_TOKEN'] || '').strip.length > 0
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
  puts 'Code Climate coverage reporter activated'
end

require 'rack-webpack'

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
end
