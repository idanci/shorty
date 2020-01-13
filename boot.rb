require 'sequel'

Sequel::Model.plugin :json_serializer

DB = Sequel.connect(adapter: :postgres, database: "shorty_#{ENV['RACK_ENV']}", host: ENV['DB_HOST'], user: 'shortyusr')

Dir[File.expand_path('../models/**/*.rb', __FILE__)].each do |file|
  dirname = File.dirname(file)
  file_basename = File.basename(file, File.extname(file))
  require "#{dirname}/#{file_basename}"
end

require File.expand_path('../api',  __FILE__)
