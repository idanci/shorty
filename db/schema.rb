Sequel.migration do
  change do
    create_table(:schema_info) do
      Integer :version, :default=>0, :null=>false
    end
    
    create_table(:urls) do
      primary_key :id
      String :url, :text=>true, :null=>false
      String :shortcode, :size=>6, :null=>false
    end
  end
end
