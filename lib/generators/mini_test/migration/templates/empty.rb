require_relative '../test_helper'
<% module_namespacing do -%>
  class <%= class_name %>MigrationTest < MigrationTest
    def test_<%= file_name %>_table_schema
      migrate version: version_before(0) 

      migrate version: 0 

      assert_table :table_name do
      end

      migrate version: version_before(0) 
    end
    def test_<%= file_name %>_table_data
      migrate version: version_before(0) 

      migrate version: 0 

      sql.execute "INSERT INTO ..."

      sql.select_one "SELECT * FROM ..."

      migrate version: version_before(0) 
    end
  end
<% end %>