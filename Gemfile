source 'https://rubygems.org'

# # Load ruby version from .ruby-version
ruby File.read( File.expand_path('../.ruby-version', __FILE__) ).strip

gemspec


# Gems for running on CI
group :test do
  gem 'simplecov'
  gem 'codeclimate-test-reporter', require: false
end
