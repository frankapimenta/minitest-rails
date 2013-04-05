	require "test_helper"

# TODO: missing null values tests

<% module_namespacing do -%>
  	class <%= class_name %>MigrationTest < ActiveSupport::TestCase
	<% if migration_action == 'add' %> 
		def test_<%= file_name %>_table_schema
	            migrate version: version_before(0)
	            # assert existance of table, columns or index

	            migrate version: 0
	            assert_table :<%= table_name %> do |t|
		                    t.integer	:id
	                <%- attributes.sort_by(&:type).each do |attr| -%>
	                    <%- if attr.type.to_sym == :references %>
		            	    <%= "t.integer 	:#{attr.name}_id" -%> 
		            	    <%= "t.index     :#{attr.name}_id, name: 'index_#{table_name}_on_#{attr.name}_id', unique: #{attr.has_uniq_index?}" if attr.attr_options.has_key?(:index) %>
	                    <%- else %>
	                	    <%= "t.#{attr.type} 	:#{attr.name}#{", #{attr.attr_options}" unless attr.attr_options.empty?}" %>
	                	    <%= "t.index 	:#{attr.name}, name: 'index_#{table_name}_on_#{attr.name}'#{", unique: #{attr.has_uniq_index?}"}" if attr.has_index? %>
	                    <%- end -%>
	                <%- end %>
		                    t.datetime	:created_at
		                    t.datetime	:updated_at

	            migrate version: version_before(0)
	            # assert existance of table, columns or index
		end

		def test_<%= file_name %>_table_data
	            migrate version: 0
        
 				#<%= table_name %>
	            _id = 1

	            <%- attributes.sort_by(&:type).each do |attr| -%>
	                <%- case attr.type.to_s -%>
		            <%- when 'binary' -%>
		            <%= "_#{attr.name} = 0b1101" %>
		            <%- when 'boolean' -%>
		            <%= "_#{attr.name} = true" %>
		            <%- when 'date' -%>
		            <%= "_#{attr.name} = #{Time.now.to_date.to_s}" %>
		            <%- when 'datetime' -%>
		            <%= "_#{attr.name} = #{DateTime.now.strftime('%Y-%m-%d %H:%M:%S')}" %>
		            <%- when 'decimal' -%>
		            <%= "_#{attr.name} = 10" %>
		            <%- when 'float' -%>
		            <%= "_#{attr.name} = 10.1" %>
		            <%- when 'integer' -%>
		            <%= "_#{attr.name} = 2" %>
		            <%- when 'references' -%>
		            <%= "_#{attr.name}_id = 1" %>
		            <%- when 'string' -%>
		            <%= "_#{attr.name} = 'some data'" %>
		            <%- when 'text' -%>
		            <%= "_#{attr.name} = 'some data really bigggggggg'" %>
		            <%- when 'time' -%>
		            <%= "_#{attr.name} = #{Time.now.to_s}" %>
		            <%- else %>
	                <%- end -%>
	            <%- end -%>
        
	            _created_at = 2.day.ago.strftime("%Y-%m-%d %H:%M:%S")
	            _updated_at = 1.day.ago.strftime("%Y-%m-%d %H:%M:%S")        
	            _created_at = 2.day.ago.strftime("%Y-%m-%d %H:%M:%S")
	            _updated_at = 1.day.ago.strftime("%Y-%m-%d %H:%M:%S")
        
	            sql.execute "INSERT INTO <%= table_name %> (id,<%- attributes.sort_by(&:type).each do |attr| -%> <%= attr.type == :references ? "#{attr.name.to_s}_id" : "#{attr.name.to_s}," %> <% end %>..., created_at, updated_at)
	            		 VALUES (\"#{_id}\",<%- attributes.sort_by(&:type).each do |attr| -%> <%= attr.type == :references ? "\\\"\#\{_#{attr.name.to_s}_id\}\\\"," : "\\\"\#\{_#{attr.name.to_s}\}\\\"," %> <% end %>\"#{...}\", \"#{_created_at}\", \"#{_updated_at}\")"
        
	            _<%= table_name %>_row  = sql.select_one "SELECT * FROM <%= table_name %>"
        
	            assert_equal _id, _<%= table_name %>_row['id'].to_i
	            <%- attributes.sort_by(&:type).each do |attr| -%>
	                <%- case attr.type.to_s -%>
		            <%- when 'binary' %>
		            <%= "assert_equal _#{attr.name},  _#{table_name}_row['#{attr.name}']" -%>
		            <%- when 'boolean' %>
		            <%= "assert _#{table_name}_row['#{attr.name}']" -%>
		            <%- when 'date' %>
		            <%= "assert_equal _#{attr.name}, _#{table_name}_row['#{attr.name}']" -%>
		            <%- when 'datetime' %>
		            <%= "assert_equal _#{attr.name}, _#{table_name}_row['#{attr.name}']" -%>
		            <%- when 'decimal' %>
		            <%= "assert_equal _#{attr.name}, _#{table_name}_row['#{attr.name}'].to_int" -%>
		            <%- when 'float' %>
		            <%= "assert_equal _#{attr.name}, _#{table_name}_row['#{attr.name}'].to_f" -%>
		            <%- when 'integer' %>
		            <%= "assert_equal _#{attr.name}, _#{table_name}_row['#{attr.name}'].to_i" -%>
		            <%- when 'references' %>
		            <%= "assert_equal _#{attr.name}_id, _#{table_name}_row['#{attr.name}_id'].to_i" -%>
		            <%- when 'string' %>
		            <%= "assert_equal _#{attr.name}, _#{table_name}_row['#{attr.name}']" -%>
		            <%- when 'text' %>
		            <%= "assert_equal _#{attr.name}, _#{table_name}_row['#{attr.name}']" -%>
		            <%- when 'time' %>
		            <%= "assert_equal _#{attr.name}, _#{table_name}_row['#{attr.name}']" -%>
		            <%- else %>
	                <%- end -%>
	            <%- end %>

	            assert_equal _created_at, _<%= table_name %>_row['created_at']
	            assert_equal _updated_at, _<%= table_name %>_row['updated_at']        
	            migrate version: version_before(0)
		end
	<% elsif migration_action == 'remove' %>
		def test_<%= file_name %>_table_schema
	            migrate version: version_before(0)
	            # assert existance of table, columns or index

	            migrate version: 0
	            assert_table :<%= table_name %> do |t|
		           	t.integer			:id
		           	# other columns
		           	t.datetime			:created_at
		           	t.datetime			:updated_at
	            end

	            migrate version: version_before(0)
	            # assert existance of table, columns or index
		end

		def test_<%= file_name %>_table_data
	            migrate version: 0
        
	            # table <%= table_name %>
	            _id = 1
        
	            _created_at = 2.day.ago.strftime("%Y-%m-%d %H:%M:%S")
	            _updated_at = 1.day.ago.strftime("%Y-%m-%d %H:%M:%S")
        
	            sql.execute "INSERT INTO <%= table_name %> (id, ..., created_at, updated_at) VALUES (\"#{_id}\", \"#{...}\", \"#{_created_at}\", \"#{_updated_at}\")"
        
	            _<%= table_name %>_row  = sql.select_one "SELECT * FROM <%= table_name %>"
        
	            assert_equal _id,           _<%= table_name %>_row['id'].to_i
	            # assert other_columns
	            assert_equal _created_at,   _<%= table_name %>_row['created_at']
	            assert_equal _updated_at,   _<%= table_name %>_row['updated_at']
        
	            migrate version: version_before(0)
		end
	<% elsif migration_action == 'join' %>
		def test_<%= file_name %>_table_schema
	    		migrate version: version_before(0)
	    		# assert existance of table, columns or index

	    		migrate version: 0
	    		assert_table :<%= join_tables.join('_') %> do |t|
		          t.integer			:id
	    		  <% attributes.each_with_index do |attr, index| %>
				    <%= "t.integer	:#{attr.name}_id" %>
				    <%= "# t.index  	[:#{(attributes-[attr]).first.name}_id, :#{attr.name}_id], name: 'index_#{join_tables.join('_')}_on_#{attributes.rotate(index).map(&:name).join('_id_and_on_')}_id', unique: false" %>
	    		  <% end %>
	    		end

	    		migrate version: version_before(0)
		    	# assert existance of table, columns or index
		end
		def test_<%= file_name %>_table_data
			migrate version: 0
	
	    	<% join_tables.each do |table| %>
			# table <%= table %>
			_id = 1
	
			# other columns
			_created_at = 2.day.ago.strftime("%Y-%m-%d %H:%M:%S")
			_updated_at = 1.day.ago.strftime("%Y-%m-%d %H:%M:%S")
	
			sql.execute "INSERT INTO <%= table %> (id, ..., created_at, updated_at) VALUES(\"#{_id}\", \"#{}\", \"#{_created_at}\", \"#{_updated_at}\")"
			<% end %>
			# table <%= join_tables.join('_') %>
			_<%= attributes.first.name %>_id  = 1
			_<%= attributes.second.name %>_id = 1
	
			sql.execute "INSERT INTO <%= join_tables.join('_') %> (<%= attributes.first.name  %>_id, <%= attributes.second.name %>_id) VALUES(\"#{_<%= attributes.first.name  %>_id }\", \"#{_<%= attributes.second.name %>_id }\")"
			_<%= join_tables.join('_') %>_row  = sql.select_one "SELECT <%= join_tables.first %>.* FROM <%= join_tables.first %>
	    							INNER JOIN <%= join_tables.join('_') %> ON <%= join_tables.join('_') %>.<%= attributes.first.name %>_id = <%= join_tables.first %>.id
					    			INNER JOIN <%= join_tables.second %> ON <%= join_tables.join('_')%>.<%= attributes.second.name %>_id = <%= join_tables.second %>.id
					    			WHERE <%= join_tables.first %>.id = \"#{_<%= attributes.first.name %>_id}\" AND <%= join_tables.second %>.id = \"#{_<%= attributes.second.name %>_id}\""
	
	
	    		assert_equal _<%= attributes.first.name %>_id,     _<%= join_tables.join('_') %>_row['id'].to_i
	    		# assert other_columns
	    		assert_equal _created_at,   _<%= join_tables.join('_') %>_row['created_at']
	    		assert_equal _updated_at,   _<%= join_tables.join('_') %>_row['updated_at']

			migrate version: version_before(0)
	    	end
	<% else %>
		def test_<%= file_name %>_table_schema
	            migrate version: version_before(0)
	            # assert existance of table, columns or index

	            migrate version: 0
	            assert_table :<%= table_name %> do |t|
		                    t.integer	:id
	                <%- attributes.sort_by(&:type).each do |attr| -%>
	                    <%- if attr.type.to_sym == :references %>
		            	    <%= "t.integer 	:#{attr.name}_id" -%> 
		            	    <%= "t.index     :#{attr.name}_id, name: 'index_#{table_name}_on_#{attr.name}_id', unique: #{attr.has_uniq_index?}" if attr.attr_options.has_key?(:index) %>
	                    <%- else %>
	                	    <%= "t.#{attr.type} 	:#{attr.name}#{", #{attr.attr_options}" unless attr.attr_options.empty?}" %>
	                	    <%= "t.index 	:#{attr.name}, name: 'index_#{table_name}_on_#{attr.name}'#{", unique: #{attr.has_uniq_index?}"}" if attr.has_index? %>
	                    <%- end -%>
	                <%- end %>
		                    t.datetime	:created_at
		                    t.datetime	:updated_at
	            end

	            migrate version: version_before(0)
	            # assert existance of table, columns or index
		end

		def test_<%= file_name %>_table_data
	            migrate version: 0
        
	            # table <%= table_name %>
	            _id = 1

	            <%- attributes.sort_by(&:type).each do |attr| -%>
	                <%- case attr.type.to_s -%>
		            <%- when 'binary' -%>
		            <%= "_#{attr.name} = 0b1101" %>
		            <%- when 'boolean' -%>
		            <%= "_#{attr.name} = true" %>
		            <%- when 'date' -%>
		            <%= "_#{attr.name} = #{Time.now.to_date.to_s}" %>
		            <%- when 'datetime' -%>
		            <%= "_#{attr.name} = #{DateTime.now.strftime('%Y-%m-%d %H:%M:%S')}" %>
		            <%- when 'decimal' -%>
		            <%= "_#{attr.name} = 10" %>
		            <%- when 'float' -%>
		            <%= "_#{attr.name} = 10.1" %>
		            <%- when 'integer' -%>
		            <%= "_#{attr.name} = 2" %>
		            <%- when 'references' -%>
		            <%= "_#{attr.name}_id = 1" %>
		            <%- when 'string' -%>
		            <%= "_#{attr.name} = 'some data'" %>
		            <%- when 'text' -%>
		            <%= "_#{attr.name} = 'some data really bigggggggg'" %>
		            <%- when 'time' -%>
		            <%= "_#{attr.name} = #{Time.now.to_s}" %>
		            <%- else %>
	                <%- end -%>
	            <%- end -%>
        
	            _created_at = 2.day.ago.strftime("%Y-%m-%d %H:%M:%S")
	            _updated_at = 1.day.ago.strftime("%Y-%m-%d %H:%M:%S")
        
	            sql.execute "INSERT INTO <%= table_name %> (id, <% attributes.sort_by(&:type).each do |attr| -%> <%= attr.type == :references ? "#{attr.name.to_s}_id" : "#{attr.name.to_s}," %> <% end %> created_at, updated_at)
	            		 VALUES (\"#{_id}\", <% attributes.sort_by(&:type).each do |attr| -%> <%= attr.type == :references ? "\\\"\#\{_#{attr.name.to_s}_id\}\\\"," : "\\\"\#\{_#{attr.name.to_s}\}\\\"," %> <% end %>\"#{_created_at}\", \"#{_updated_at}\")"
        
	            _<%= table_name %>_row  = sql.select_one "SELECT * FROM <%= table_name %> WHERE id = \"#{_id}\""
        
	            assert_equal _id, _<%= table_name %>_row['id'].to_i
	            <%- attributes.sort_by(&:type).each do |attr| -%>
	                <%- case attr.type.to_s -%>
		            <%- when 'binary' %>
		            <%= "assert_equal _#{attr.name},  _#{table_name}_row['#{attr.name}']" -%>
		            <%- when 'boolean' %>
		            <%= "assert _#{table_name}_row['#{attr.name}']" -%>
		            <%- when 'date' %>
		            <%= "assert_equal _#{attr.name}, _#{table_name}_row['#{attr.name}']" -%>
		            <%- when 'datetime' %>
		            <%= "assert_equal _#{attr.name}, _#{table_name}_row['#{attr.name}']" -%>
		            <%- when 'decimal' %>
		            <%= "assert_equal _#{attr.name}, _#{table_name}_row['#{attr.name}'].to_int" -%>
		            <%- when 'float' %>
		            <%= "assert_equal _#{attr.name}, _#{table_name}_row['#{attr.name}'].to_f" -%>
		            <%- when 'integer' %>
		            <%= "assert_equal _#{attr.name}, _#{table_name}_row['#{attr.name}'].to_i" -%>
		            <%- when 'references' %>
		            <%= "assert_equal _#{attr.name}_id, _#{table_name}_row['#{attr.name}_id'].to_i" -%>
		            <%- when 'string' %>
		            <%= "assert_equal _#{attr.name}, _#{table_name}_row['#{attr.name}']" -%>
		            <%- when 'text' %>
		            <%= "assert_equal _#{attr.name}, _#{table_name}_row['#{attr.name}']" -%>
		            <%- when 'time' %>
		            <%= "assert_equal _#{attr.name}, _#{table_name}_row['#{attr.name}']" -%>
		            <%- else %>
	                <%- end -%>
	            <%- end %>

	            assert_equal _created_at, _<%= table_name %>_row['created_at']
	            assert_equal _updated_at, _<%= table_name %>_row['updated_at']
        
	            migrate version: version_before(0)
		end
	<% end %>
	end
<% end -%>
