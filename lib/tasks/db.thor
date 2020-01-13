# frozen_string_literal: true

require 'pathname'
require 'sequel'

class Db < Thor
  include Thor::Actions

  APP_ROOT = Pathname.new(File.expand_path('../../', __dir__))

  desc 'migrate', 'Migrate databases'
  def migrate
    env = ENV['RACK_ENV'] || 'development'
    host = ENV['DB_HOST'] || 'db'

    db = Sequel.connect(adapter: :postgres, database: "shorty_#{env}", host: host, user: 'shortyusr')
    Sequel.extension :migration
    Sequel::Migrator.run(db, APP_ROOT.join('db/migrate'))
  end
end
