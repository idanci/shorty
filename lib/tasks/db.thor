# frozen_string_literal: true

require 'pathname'
require 'sequel'

class Db < Thor
  include Thor::Actions

  DB_PATH = Pathname.new(File.expand_path('../../db', __dir__))

  desc 'migrate', 'Migrate database'
  def migrate
    Sequel.extension :migration
    Sequel::Migrator.run(db, DB_PATH.join('migrate'))

    dump_schema
  end

  desc 'rollback', 'Rollback database'
  def rollback
    version = if db.tables.include?(:schema_info)
      db[:schema_info].first[:version]
    end || 0

    target = version.zero? ? 0 : (version - 1)

    Sequel.extension :migration
    Sequel::Migrator.run(db, DB_PATH.join('migrate'), :target => target.to_i)

    dump_schema
  end

  private

  def dump_schema
    db.extension(:schema_dumper)
    schema = db.dump_schema_migration(indexes: true, foreign_keys: true, same_db: true)
    File.open(DB_PATH.join('schema.rb'), 'w') {|f| f.write(schema) }
  end

  def db
    @db ||= Sequel.connect(
      adapter: :postgres,
      database: "shorty_#{ENV['RACK_ENV'] || 'development'}",
      host: ENV['DB_HOST'] || 'localhost',
      user: 'shortyusr'
    )
  end
end
