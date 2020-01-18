Sequel.migration do
  change do
    create_table(:schema_info) do
      column :version, "integer", :default=>0, :null=>false
    end
    
    create_table(:urls) do
      primary_key :id
      column :url, "text", :null=>false
      column :shortcode, "character varying(6)", :null=>false
      column :last_visit, "timestamp without time zone"
      column :redirect_count, "integer", :default=>0, :null=>false
      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"
      
      index [:shortcode]
      index [:shortcode], :name=>:urls_shortcode_key, :unique=>true
    end
  end
end
