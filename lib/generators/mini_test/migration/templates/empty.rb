require_relative '../test_helper'
<% module_namespacing do -%>
  class <%= class_name %>MigrationTest < MigrationTest
    def test_<%= file_name %>_table_schema
      migrate version: version_before(<%= Time.now.utc.strftime("%Y%m%d%H%M%S") -%>) 

      migrate version: <%= Time.now.utc.strftime("%Y%m%d%H%M%S") -%> 

      assert_table :table_name do
      end

      migrate version: version_before(<%= Time.now.utc.strftime("%Y%m%d%H%M%S") -%>) 
    end
    def test_<%= file_name %>_table_data
      migrate version: version_before(<%= Time.now.utc.strftime("%Y%m%d%H%M%S") -%>) 

      migrate version: <%= Time.now.utc.strftime("%Y%m%d%H%M%S") -%> 

      sql.execute "INSERT INTO ..."

      sql.select_one "SELECT * FROM ..."

      migrate version: version_before(<%= Time.now.utc.strftime("%Y%m%d%H%M%S") -%>) 
    end
  end
<% end %>