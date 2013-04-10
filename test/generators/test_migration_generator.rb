require "helper"
require "generators/mini_test/migration/migration_generator"

class TestMigrationGenerator < GeneratorTest

  def test_migration_generator_for_create
    assert_output(/create  test\/migrate\/create_users_test.rb/m) do
      _generator_options = ["create_users", "company:references", "world:references:uniq", "name:string", "email:string:index", "guid:integer:uniq", "admin:boolean"]
      MiniTest::Generators::MigrationGenerator.start _generator_options
    end
    assert File.exists? "test/migrate/create_users_test.rb"
    contents = File.read "test/migrate/create_users_test.rb"
    assert_match(/class CreateUsersMigrationTest/m, contents, "wrong class name")
    assert_match(/def test_create_users_table_schema/m, contents, "wrong method name for test table schema")
    assert_match(/assert_table :users/, contents, "assert table not present")
    assert_match(/t.integer\s+:id/, contents, "id column not present")
    assert_match(/t.integer\s+:company_id/, contents, "company_id column not present")
    assert_match(/t.index\s+:company_id, name: 'index_users_on_company_id', unique: false/, contents, "index not present or wrong index options for company_id foreign key")
    assert_match(/t.integer\s+:world_id/, contents, "world_id column not present")
    assert_match(/t.index\s+:world_id, name: 'index_users_on_world_id', unique: false/, contents, "index not present or wrong index options for world_id foreign key")
    assert_match(/t.string\s+:name/, contents, "name column not present")
    assert_match(/t.string\s+:email/, contents, "email column not present")
    assert_match(/t.index\s+:email, name: 'index_users_on_email', unique: false/, contents, "index not present or wrong index options for guid attribute")
    assert_match(/t.integer\s+:guid/, contents, "guid column not present")
    assert_match(/t.index\s+:guid, name: 'index_users_on_guid', unique: true/, contents, "index not present or wrong index options for guid attribute")
    assert_match(/t.boolean\s+:admin/, contents, "admin column not present")
    assert_match(/t.datetime\s+:created_at/, contents, "created_at column not present")
    assert_match(/t.datetime\s+:updated_at/, contents, "updated_at column not present")
    assert_match(/def test_create_users_table_data/m, contents, "wrong method name for test table data" )
    assert_match(/_users_row  = sql.select_one \"SELECT \* FROM users WHERE id = \\\"#\{_id\}\\\"\"/, contents, "sql row fetch did not match" )
    assert_match(/assert_equal _id, _users_row\['id'\].to_i/, contents, "assert_equal for id did not match")
    assert_match(/assert_equal _company_id, _users_row\['company_id'\].to_i/, contents, "assert_equal for company_id did not match")
    assert_match(/assert_equal _world_id, _users_row\['world_id'\].to_i/, contents, "assert_equal for world_id did not match")
    assert_match(/assert _users_row\['admin'\]/, contents, "assert_equal for admin did not match")
    assert_match(/assert_equal _name, _users_row\['name'\]/, contents, "assert_equal for name did not match")
    assert_match(/assert_equal _email, _users_row\['email'\]/, contents, "assert_equal for email did not match")
    assert_match(/assert_equal _guid, _users_row\['guid'\]/, contents, "assert_equal for guid did not match")
    assert_match(/assert_equal _created_at, _users_row\['created_at'\]/, contents, "assert_equal for _created_at did not match")
    assert_match(/assert_equal _updated_at, _users_row\['updated_at'\]/, contents, "assert_equal for _updated_at did not match")
  end

  def test_migration_generator_for_class_with_many_names
    assert_output(/create  test\/migrate\/create_product_details_test.rb/m) do
      MiniTest::Generators::MigrationGenerator.start ["create_product_details"]
    end
    assert File.exists? "test/migrate/create_product_details_test.rb"
    contents = File.read "test/migrate/create_product_details_test.rb"
    assert_match(/class CreateProductDetailsMigrationTest/m, contents, "wrong class name")
    assert_match(/def test_create_product_details_table_schema/m, contents, "wrong method name for test table schema")
    assert_match(/assert_table :product_details/, contents, "assert table not present")
    assert_match(/def test_create_product_details_table_data/m, contents, "wrong method name for test table data")
  end

  def test_migration_generator_for_join_tables
    assert_output(/create  test\/migrate\/create_join_table_groups_posts_test.rb/m) do
      MiniTest::Generators::MigrationGenerator.start ["create_join_table_groups_posts", 'group', 'post']
    end
    assert File.exists? "test/migrate/create_join_table_groups_posts_test.rb"
    contents = File.read "test/migrate/create_join_table_groups_posts_test.rb"
    assert_match(/class CreateJoinTableGroupsPostsMigrationTest/m, contents, "wrong class name")
    assert_match(/def test_create_join_table_groups_posts_table_schema/m, contents, "wrong method name for test table schema")
    assert_match(/assert_table :groups_posts/, contents, "assert table not present")
    assert_match(/t.integer\s+:group_id/, contents, "group_id column not present")
    assert_match(/t.integer\s+:post_id/, contents, "post_id column not present")
    assert_match(/# t.index\s+\[:post_id, :group_id\], name: 'index_groups_posts_on_post_id_and_on_group_id', unique: true/, contents, "index for post_id, groupd_id not present")
    assert_match(/# t.index\s+\[:group_id, :post_id\], name: 'index_groups_posts_on_group_id_and_on_post_id', unique: true/, contents, "index for groupd_id, post_id not present")
    assert_match(/def test_create_join_table_groups_posts_table_data/m, contents, "wrong method name for test table data")
    assert_match(/INSERT INTO groups \(id, \.\.\., created_at, updated_at\) VALUES\(\\\"\#\{_id\}\\\", \\\"\#\{\}\\\", \\\"\#\{_created_at\}\\\", \\\"\#\{_updated_at\}\\\"\)/, contents, "no data being inserted in first table")
    assert_match(/INSERT INTO posts \(id, \.\.\., created_at, updated_at\) VALUES\(\\\"\#\{_id\}\\\", \\\"\#\{\}\\\", \\\"\#\{_created_at\}\\\", \\\"\#\{_updated_at\}\\\"\)/, contents, "no data being inserted in second table")
    assert_match(/SELECT groups\.\* FROM groups\s+INNER JOIN groups_posts ON groups_posts\.group_id = groups\.id\s+INNER JOIN posts ON groups_posts\.post_id = posts\.id\s+WHERE groups\.id = \\\"\#\{_group_id\}\\\" AND posts\.id = \\\"\#\{_post_id\}\\\"/, contents, "no data being fetch from tables joins")
    assert_match(/assert_equal _created_at,\s+_groups_posts_row\['created_at'\]/, contents, "assert_equal for _created_at did not match")
    assert_match(/assert_equal _updated_at,\s+_groups_posts_row\['updated_at'\]/, contents, "assert_equal for _updated_at did not match")
  end
    
  def test_migration_generator_for_add_column
    assert_output(/create  test\/migrate\/add_email_to_posts_test.rb/m) do
      MiniTest::Generators::MigrationGenerator.start ["add_email_to_posts", 'email:uniq']
    end
    assert File.exists? "test/migrate/add_email_to_posts_test.rb"
    contents = File.read "test/migrate/add_email_to_posts_test.rb"
    assert_match(/class AddEmailToPostsMigrationTest/m, contents)
    assert_match(/def test_add_email_to_posts_table_schema/m, contents)
    assert_match(/assert_table :posts/, contents, "assert table not present")
    assert_match(/t.integer\s+:id/, contents, "id column not present")
    assert_match(/t.index\s+:email, name: 'index_posts_on_email', unique: true/, contents, "index not present or wrong index options for email attribute")
    assert_match(/def test_add_email_to_posts_table_data/m, contents, "wrong method name for test table data")
    assert_match(/_email = 'some data'/m, contents, "no variable _email is present")
    assert_match(/INSERT INTO posts \(id, email, \.\.\., created_at, updated_at\)\s*VALUES \(\\\"\#\{_id\}\\\", \\\"\#\{_email\}\\\", \\\"\#\{\.\.\.\}\\\", \\\"\#\{_created_at\}\\\", \\\"\#\{_updated_at\}\\\"\)/m, contents, "no data being inserted in posts table")
    assert_match(/SELECT \* FROM posts/m, contents, "no data fetched from posts table")
    assert_match(/assert_equal _id, _posts_row\['id'\].to_i/, contents, "assert_equal for id did not match")
    assert_match(/assert_equal _email, _posts_row\['email'\]/, contents, "assert_equal for email did not match")
    assert_match(/assert_equal _created_at, _posts_row\['created_at'\]/, contents, "assert_equal for _created_at did not match")
    assert_match(/assert_equal _updated_at, _posts_row\['updated_at'\]/, contents, "assert_equal for _updated_at did not match")
  end

  def test_migration_generator_for_add_column_with_unique_index
    assert_output(/create  test\/migrate\/add_email_to_posts_test.rb/m) do
      MiniTest::Generators::MigrationGenerator.start ["add_email_to_posts", 'email:uniq']
    end
    assert File.exists? "test/migrate/add_email_to_posts_test.rb"
    contents = File.read "test/migrate/add_email_to_posts_test.rb"
    assert_match(/t.index\s+:email, name: 'index_posts_on_email', unique: true/, contents, "index not present or wrong index options for email attribute")
  end

  def test_migration_generator_for_add_column_with_non_unique_index
    assert_output(/create  test\/migrate\/add_email_to_posts_test.rb/m) do
      MiniTest::Generators::MigrationGenerator.start ["add_email_to_posts", 'email:index']
    end
    assert File.exists? "test/migrate/add_email_to_posts_test.rb"
    contents = File.read "test/migrate/add_email_to_posts_test.rb"
    assert_match(/t.index\s+:email, name: 'index_posts_on_email', unique: false/, contents, "index not present or wrong index options for email attribute")
  end

  def test_migration_generator_for_add_column_with_no_index
    assert_output(/create  test\/migrate\/add_email_to_posts_test.rb/m) do
      MiniTest::Generators::MigrationGenerator.start ["add_email_to_posts", 'email:string']
    end
    assert File.exists? "test/migrate/add_email_to_posts_test.rb"
    contents = File.read "test/migrate/add_email_to_posts_test.rb"
    refute_match(/t.index\s+:email, name: 'index_posts_on_email', unique: true/, contents, "index not present or wrong index options for email attribute")
  end

  def test_migration_generator_for_add_references_to_account
    assert_output(/create  test\/migrate\/add_account_references_to_posts_test.rb/m) do
      MiniTest::Generators::MigrationGenerator.start ["add_account_references_to_posts", 'account:references']
    end
    assert File.exists? "test/migrate/add_account_references_to_posts_test.rb"
    contents = File.read "test/migrate/add_account_references_to_posts_test.rb"
    assert_match(/t.integer\s+:account_id/, contents, "reference account_id not present")
    assert_match(/t.index\s+:account_id, name: 'index_posts_on_account_id', unique: false/, contents, "index not present or wrong index options for email attribute")
  end

  def test_migration_generator_for_remove_column_of_type_boolean
    assert_output(/create  test\/migrate\/remove_email_from_posts_test.rb/m) do
      MiniTest::Generators::MigrationGenerator.start ["remove_email_from_posts", 'email:string']
    end
    assert File.exists? "test/migrate/remove_email_from_posts_test.rb"
    contents = File.read "test/migrate/remove_email_from_posts_test.rb"
    assert_match(/class RemoveEmailFromPostsMigrationTest/m, contents)
    assert_match(/def test_remove_email_from_posts_table_schema/m, contents)
    assert_match(/assert_table :posts/, contents, "assert table not present")
    assert_match(/t.integer\s+:id/, contents, "id column not present")
    assert_match(/def test_remove_email_from_posts_table_data/m, contents, "wrong method name for test table data")
    assert_match(/INSERT INTO posts \(id, \.\.\., created_at, updated_at\)\s*VALUES \(\\\"\#\{_id\}\\\", \\\"\#\{\.\.\.\}\\\", \\\"\#\{_created_at\}\\\", \\\"\#\{_updated_at\}\\\"\)/m, contents, "no data being inserted in posts table")
    assert_match(/SELECT \* FROM posts/m, contents, "no data fetched from posts table")
    assert_match(/assert_equal _id,\s+_posts_row\['id'\].to_i/, contents, "assert_equal for id did not match")
    assert_match(/assert_equal _created_at,\s+_posts_row\['created_at'\]/, contents, "assert_equal for _created_at did not match")
    assert_match(/assert_equal _updated_at,\s+_posts_row\['updated_at'\]/, contents, "assert_equal for _updated_at did not match")
  end
end