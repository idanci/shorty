require 'rack/test'
require 'rspec'
require 'database_cleaner'
require 'fabrication'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../boot.rb', __FILE__
require File.expand_path '../../spec/fabricators/url_fabricator.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |config|
  config.include RSpecMixin

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
