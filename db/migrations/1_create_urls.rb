Sequel.migration do
  change do
    create_table(:urls) do
      primary_key :id

      String :location, null: false
      String :shortcode, null: false
    end
  end
end
