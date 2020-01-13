# frozen_string_literal: true

require_relative '../../boot'
require 'pathname'

class Db < Thor
  include Thor::Actions

  DB_PATH = Pathname.new(File.expand_path('../../db', __dir__))#.join('db/migrate')

  desc 'migrate', 'Migrate database'
  def migrate
    Sequel.extension :migration
    Sequel::Migrator.run(DB, DB_PATH.join('migrate'))

    dump_schema
  end

  desc 'rollback', 'Rollback database'
  def rollback
    version = if DB.tables.include?(:schema_info)
      DB[:schema_info].first[:version]
    end || 0

    target = version.zero? ? 0 : (version - 1)

    Sequel.extension :migration
    Sequel::Migrator.run(DB, DB_PATH.join('migrate'), :target => target.to_i)

    dump_schema
  end

  private

  def dump_schema
    DB.extension(:schema_dumper)
    schema = DB.dump_schema_migration(indexes: true, foreign_keys: true)
    File.open(DB_PATH.join('schema.rb'), 'w') {|f| f.write(schema) }
  end
end
