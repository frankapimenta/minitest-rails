require_relative '../test_helper'
<% module_namespacing do -%>
  class <%= class_name %>MigrationTest < MigrationTest
  	<%- if migration_action == 'add' -%>
      def test_<%= file_name %>_table_schema
        migrate version: version_before(0)
        # assert existance of table, columns or index
        assert sql.table_exists?(:<%= table_name %>)
        <%- attributes.each do |attribute| -%>
        assert !sql.column_exists?(:<%= table_name %>, :<%= attribute.name %>)
        <%- end -%>

        migrate version: 0
        assert_table :<%= table_name %> do |t|
          t.integer	:id
          <%- attributes.each do |attribute| -%>
          <%- if attribute.type.to_sym == :references %>
          <%= "t.integer	:#{attribute.name}_id" -%> 
          <%= "t.index	    :#{attribute.name}_id, name: 'index_#{table_name}_on_#{attribute.name}_id', unique: false" %>
          <%- else %>
          <%= "t.#{attribute.type}	:#{attribute.name}#{", #{attribute.attr_options}" unless attribute.attr_options.empty?}" %>
          <%= "t.index       :#{attribute.name}, name: 'index_#{table_name}_on_#{attribute.name}'#{", unique: #{attribute.has_uniq_index?}"}" if attribute.has_index? %>
          <%- end -%>
          <%- end -%>
          t.datetime	:created_at
          t.datetime	:updated_at
        end

        migrate version: version_before(0)
        # assert existance of table, columns or index
        assert sql.table_exists?(:<%= table_name %>)
        <%- attributes.each do |attribute| -%>
        assert !sql.column_exists?(:<%= table_name %>, :<%= attribute.name %>)
        <%- end -%>
      end

      def test_<%= file_name %>_table_data
        migrate version: 0

        _id = 1

        <%- attributes.each do |attribute| -%>
        <%- case attribute.type.to_s -%>
        <%- when 'binary' 	-%>
          <%= "_#{attribute.name} = 0b1101" %>
        <%- when 'boolean'	-%>
          <%= "_#{attribute.name} = true" %>
        <%- when 'date' 	-%>
        <%= "_#{attribute.name} = #{Time.now.to_date.to_s}" %>
        <%- when 'datetime'	-%>
        <%= "_#{attribute.name} = #{DateTime.now.strftime('%Y-%m-%d %H:%M:%S')}" %>
        <%- when 'decimal'  -%>
        <%= "_#{attribute.name} = 10" %>
        <%- when 'float'		-%>
        <%= "_#{attribute.name} = 10.1" %>
        <%- when 'integer'  -%>
        <%= "_#{attribute.name} = 2" %>
        <%- when 'references'	-%>
        <%= "_#{attribute.name}_id = 1" %>
        <%- when 'string' 		-%>
        <%= "_#{attribute.name} = 'some data'" %>
        <%- when 'text'				-%>
        <%= "_#{attribute.name} = 'some data really bigggggggg'" %>
        <%- when 'time' 			-%>
        <%= "_#{attribute.name} = #{Time.now.to_s}" %>
        <%- else %>
        "attribute requested not recognized"
        <%- end -%>
        <%- end -%>

        _created_at = 2.day.ago.strftime("%Y-%m-%d %H:%M:%S")
        _updated_at = 1.day.ago.strftime("%Y-%m-%d %H:%M:%S")        

        sql.execute "INSERT INTO <%= table_name %> (id,<%- attributes.each do |attribute| -%> <%= attribute.type == :references ? "#{attribute.name.to_s}_id, " : "#{attribute.name.to_s}," %> <% end %>..., created_at, updated_at)
        VALUES (\"#{_id}\",<%- attributes.each do |attribute| -%> <%= attribute.type == :references ? "\\\"\#\{_#{attribute.name.to_s}_id\}\\\"," : "\\\"\#\{_#{attribute.name.to_s}\}\\\"," %> <% end %>\"#{...}\", \"#{_created_at}\", \"#{_updated_at}\")"

        _<%= table_name %>_row  = sql.select_one "SELECT * FROM <%= table_name %>"

        assert_equal _id, _<%= table_name %>_row['id'].to_i
        <%- attributes.each do |attribute| -%>
        <%- case attribute.type.to_s -%>
        <%- when 'binary'				-%>	
        <%= "assert_equal _#{attribute.name},  _#{table_name}_row['#{attribute.name}']" %>
        <%- when 'boolean' 		  -%>
        <%= "assert _#{table_name}_row['#{attribute.name}']" %>
        <%- when 'date'					-%>
        <%= "assert_equal _#{attribute.name}, _#{table_name}_row['#{attribute.name}']" %>
        <%- when 'datetime' 		-%>  
        <%= "assert_equal _#{attribute.name}, _#{table_name}_row['#{attribute.name}']" %>
        <%- when 'decimal'			-%>
        <%= "assert_equal _#{attribute.name}, _#{table_name}_row['#{attribute.name}'].to_int" %>
        <%- when 'float'				-%>
        <%= "assert_equal _#{attribute.name}, _#{table_name}_row['#{attribute.name}'].to_f" %>
        <%- when 'integer'			-%>
        <%= "assert_equal _#{attribute.name}, _#{table_name}_row['#{attribute.name}'].to_i" %>
        <%- when 'references'		-%>
        <%= "assert_equal _#{attribute.name}_id, _#{table_name}_row['#{attribute.name}_id'].to_i" %>
        <%- when 'string'				-%>	
        <%= "assert_equal _#{attribute.name}, _#{table_name}_row['#{attribute.name}']" %>
        <%- when 'text'					-%>
        <%= "assert_equal _#{attribute.name}, _#{table_name}_row['#{attribute.name}']" %>
        <%- when 'time' 				-%>
        <%= "assert_equal _#{attribute.name}, _#{table_name}_row['#{attribute.name}']" %>
        <%- else %>
        "attribute requested not recognized"
        <%- end -%>
        <%- end -%>
        assert_equal _created_at, _<%= table_name %>_row['created_at']
        assert_equal _updated_at, _<%= table_name %>_row['updated_at']        

        migrate version: version_before(0)
      end
    <%- end -%>
    <%- if migration_action == 'remove' -%>
      def test_<%= file_name %>_table_schema
        migrate version: version_before(0)
        # assert existance of table, columns or index
        assert sql.table_exists?(:<%= table_name %>)
        <%- attributes.each do |attribute| -%>
        assert sql.column_exists?(:<%= table_name %>, :<%= attribute.name %>)
        <%- end -%>

        migrate version: 0

        <%- attributes.each do |attribute| -%>
        assert !sql.column_exists?(:<%= table_name %>, :<%= attribute.name %>)
        <%- end -%>

        migrate version: version_before(0)
        # assert existance of table, columns or index
        assert sql.table_exists?(:<%= table_name %>)
        <%- attributes.each do |attribute| -%>
        assert sql.column_exists?(:<%= table_name %>, :<%= attribute.name %>)
        <%- end -%>
      end
    <%- end -%>
  end
<%- end -%>
