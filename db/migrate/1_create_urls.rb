# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:urls) do
      primary_key :id

      column :url, :text, null: false
      column :shortcode, :varchar, null: false, size: 6, index: true, unique: true
      column :last_visit, :timestamp
      column :redirect_count, :integer, null: false, default: 0, index: true

      column :created_at, :timestamp
      column :updated_at, :timestamp

      constraint(:shortcode_valid, shortcode: /^[0-9a-zA-Z_]{6}$/)
    end
  end

  down do
    drop_table :urls
  end
end
