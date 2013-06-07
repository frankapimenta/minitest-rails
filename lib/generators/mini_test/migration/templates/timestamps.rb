require_relative '../test_helper'
<% module_namespacing do -%>
  class <%= class_name %>MigrationTest < MigrationTest
  	def test_<%= file_name %>_table_schema
  		migrate version: version_before(<%= Time.now.utc.strftime("%Y%m%d%H%M%S") -%>)

  		assert sql.table_exists?(:<%= table_name %>)
  		assert !sql.column_exists?(:<%= table_name %>, :created_at)
  		assert !sql.column_exists?(:<%= table_name %>, :updated_at)

  		migrate version: <%= Time.now.utc.strftime("%Y%m%d%H%M%S") -%>

  		assert sql.table_exists?(:<%= table_name %>)
  		assert sql.column_exists?(:<%= table_name %>, :created_at)
  		assert sql.column_exists?(:<%= table_name %>, :updated_at)

  		migrate version: version_before(<%= Time.now.utc.strftime("%Y%m%d%H%M%S") -%>)
      assert sql.table_exists?(:<%= table_name %>)
      assert !sql.column_exists?(:<%= table_name %>, :created_at)
      assert !sql.column_exists?(:<%= table_name %>, :updated_at)
  	end
  end
<% end %>