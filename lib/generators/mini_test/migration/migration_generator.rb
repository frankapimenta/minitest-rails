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
      attr_reader :migration_action, :join_tables

      def set_local_assigns!
        @migration_template = "migration_test.rb"
        case file_name
        when /^(add|remove)_.*_(?:to|from)_(.*)/
          @migration_action = $1
          @table_name       = $2.pluralize
        when /join_table/
          if attributes.length == 2
            @migration_action  = 'join'
            @join_tables       = attributes.map(&:plural_name)
          end
        when /^create_(.+)/
          @migration_action = 'create'
          @table_name = $1.pluralize
        end
      end
    end
  end
end
