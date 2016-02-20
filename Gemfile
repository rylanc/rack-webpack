source 'https://rubygems.org'

# Load ruby version from .ruby-version
ruby_version = File.read( File.expand_path('../.ruby-version', __FILE__) ).strip.split('-')
if ruby_version.size == 2
  ruby ruby_version[1], engine: ruby_version[0], engine_version: ruby_version[1]
elsif ruby_version.size == 3
  ruby ruby_version[1], engine: ruby_version[0], engine_version: ruby_version[1], patchlevel: ruby_version[2].gsub('p', '')
else
  raise 'Invalid .ruby-version file found'
end

gemspec


# Gems for running on CI
group :test do
  gem 'simplecov'
  gem 'codeclimate-test-reporter', require: false
end
