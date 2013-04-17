require "generators/mini_test"

module MiniTest
  module Generators
    class MigrationGenerator < Base
      argument :attributes, :type => :array, :default => [], :banner => "field[:type][:index] field[:type][:index]"

      check_class_collision :suffix => "MigrationTest"

      def create_test_file
          set_local_assigns!
          template @migration_template, File.join("test/migrate", class_path, "#{file_name}_test.rb")
      end

      protected
      attr_reader :migration_action, :join_tables, :renamed_table

      def set_local_assigns!
        @migration_template = "migration.rb"
        case file_name
        when /^(add|remove)_.*_(?:to|from)_(.*)/
          @migration_action = $1
          @table_name       = $2.pluralize
        when /join_table/
          if attributes.length == 2
            @migration_action  = 'join'
            @join_tables       = attributes.map(&:plural_name)

            set_index_names
          end
        when /^create_(.+)/
          @migration_action = 'create'
          @table_name = $1.pluralize
        when /^rename_table_(.+)_to_(.+)$/
          @migration_action = 'rename_table'
          @renamed_table = $1
          @table_name = $2
        end
      end

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
