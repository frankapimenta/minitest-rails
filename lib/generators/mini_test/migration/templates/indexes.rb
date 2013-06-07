require_relative '../test_helper'
<% module_namespacing do -%>
  class <%= class_name %>MigrationTest < MigrationTest
    def test_<%= file_name %>_table_schema
      migrate version: version_before(<%= Time.now.utc.strftime("%Y%m%d%H%M%S") -%>)

      assert sql.table_exists?(:<%= table_name %>)
      <%- attributes.each do |attribute| -%>
      assert sql.column_exists?(:<%= table_name %>, :<%= attribute.name %>)
      <%- if migration_action == 'add' -%>
      assert !sql.index_exists?(:<%= table_name %>, :<%= attribute.name %><%= ", unique: true" if attribute.has_uniq_index? %><%= ')' %>
      <%- end -%>
      <%- if migration_action == 'remove' -%>
      assert sql.index_exists?(:<%= table_name %>, :<%= attribute.name %><%= ", unique: true" if attribute.has_uniq_index? %><%= ')' %>
      <%- end -%>
      <%- end -%>

      migrate version: <%= Time.now.utc.strftime("%Y%m%d%H%M%S") -%>

      assert sql.table_exists?(:<%= table_name %>)
      <%- attributes.each do |attribute| -%>
      assert sql.column_exists?(:<%= table_name %>, :<%= attribute.name %>)
      <%- if migration_action == 'add' -%>
      assert sql.index_exists?(:<%= table_name %>, :<%= attribute.name %><%= ", unique: true" if attribute.has_uniq_index? %><%= ')' %>
      <%- end -%>
      <%- if migration_action == 'remove' -%>
      assert !sql.index_exists?(:<%= table_name %>, :<%= attribute.name %><%= ", unique: true" if attribute.has_uniq_index? %><%= ')' %>
      <%- end -%>
      <%- end -%>

      migrate version: version_before(<%= Time.now.utc.strftime("%Y%m%d%H%M%S") -%>)

      assert sql.table_exists?(:<%= table_name %>)
      <%- attributes.each do |attribute| -%>
      assert sql.column_exists?(:<%= table_name %>, :<%= attribute.name %>)
      <%- if migration_action == 'add' -%>
      assert !sql.index_exists?(:<%= table_name %>, :<%= attribute.name %><%= ", unique: true" if attribute.has_uniq_index? %><%= ')' %>
      <%- end -%>
      <%- if migration_action == 'remove' -%>
      assert sql.index_exists?(:<%= table_name %>, :<%= attribute.name %><%= ", unique: true" if attribute.has_uniq_index? %><%= ')' %>
      <%- end -%>
      <%- end -%>
    end
  end
<% end %>