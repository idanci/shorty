require 'sequel'
require 'pry-byebug'

Sequel::Model.plugin :json_serializer

host = ENV['DB_HOST'] || 'localhost'
env = ENV['RACK_ENV'] || 'development'

DB = Sequel.connect(adapter: :postgres, database: "shorty_#{env}", host: host, user: 'shortyusr')

Dir[File.expand_path('../models/**/*.rb', __FILE__)].each do |file|
  dirname = File.dirname(file)
  file_basename = File.basename(file, File.extname(file))
  require "#{dirname}/#{file_basename}"
end

require File.expand_path('../api',  __FILE__)
