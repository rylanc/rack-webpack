$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

Bundler.setup(:default, :development)

require('rack-webpack')

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
end
