require "generators/mini_test"

module MiniTest
  module Generators
    class MigrationGenerator < Base
      argument :attributes, :type => :array, :default => [], :banner => "field[:type][:index] field[:type][:index]"

      check_class_collision :suffix => "MigrationTest"

      def create_test_file
          set_local_assigns!
          _file_path = "#{Time.now.utc.strftime("%Y%m%d%H%M%S")}_#{file_name}_test.rb"
          template @migration_template, File.join("test/migrate", class_path, _file_path)
      end

      protected
      attr_reader :migration_action, :join_tables, :new_table_name

      def set_local_assigns!
        @migration_template = "migration.rb"
        case file_name
        when /^(add|remove)_(.*)_(?:to|from)_(.*)$/
          @migration_action = $1
          @table_name = $3.pluralize
          @migration_template = 'columns.rb'
          @migration_template = 'timestamps.rb' if $2 =~ /^timestamps$/ 
        when /^(add|remove)_index(?:es)?_(.*)_on_(.*)$/
          @migration_action = $1
          @table_name = $3.pluralize
          @migration_template = 'indexes.rb' 
        when /join/
          if attributes.size == 2
            @migration_action = 'join'
            @join_tables = attributes.map(&:plural_name)
            @migration_template = 'tables.rb'
          end
        when /^(create|rename)_(.+)/
            @migration_template = "tables.rb"
            @migration_action = $1
          if migration_action == 'create'
            @table_name = $2.pluralize
          else
            $2 =~ /(.*)_to_(.*)/
            @table_name, @new_table_name = $1.pluralize, $2.pluralize
          end
        else
          @migration_template = 'empty.rb'
        end
      end

      # do we need the code below?
      def set_index_names
        attributes.each_with_index do |attr, i|
          attr.index_name = [attr, attributes[i - 1]].map{ |a| index_name_for(a) }
        end
      end

      def index_name_for(attribute)
        if attribute.foreign_key?
          attribute.name
        else
          attribute.name.singularize.foreign_key
        end.to_sym
      end

      private
        def attributes_with_index
          attributes.select { |a| !a.reference? && a.has_index? }
        end
        
        def validate_file_name!
          unless file_name =~ /^[_a-z0-9]+$/
            raise IllegalMigrationNameError.new(file_name)
          end
        end
    end
  end
end
