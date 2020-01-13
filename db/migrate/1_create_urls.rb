Sequel.migration do
  change do
    create_table(:urls) do
      primary_key :id

      String :url, null: false

      column :shortcode, :varchar, null: false, size: 6

      constraint(:shortcode_valid, shortcode: /^[0-9a-zA-Z_]{6}$/)
    end
  end
end
