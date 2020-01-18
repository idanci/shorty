# frozen_string_literal: true

require 'rack/test'
require 'rspec'
require 'database_cleaner'
require 'fabrication'
require 'timecop'

ENV['RACK_ENV'] = 'test'

require File.expand_path('../boot.rb', __dir__)
require File.expand_path('../spec/fabricators/url_fabricator.rb', __dir__)

module RSpecMixin
  include Rack::Test::Methods

  def app
    API
  end
end

module Helpers
  def parsed_response
    @parsed_response ||= JSON.parse(last_response.body)
  end
end

RSpec.configure do |config|
  config.include Helpers
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
