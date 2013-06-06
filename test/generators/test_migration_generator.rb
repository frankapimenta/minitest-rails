require "helper"
require "generators/mini_test/migration/migration_generator"

class TestMigrationGenerator < GeneratorTest
    
  def test_add_single_column
    assert_output /create  test\/migrate\/add_column_title_to_posts_test.rb/m do
      MiniTest::Generators::MigrationGenerator.start ["add_column_title_to_posts", "title:string"]
    end
    assert File.exists? "test/migrate/add_column_title_to_posts_test.rb"
    contents = File.read "test/migrate/add_column_title_to_posts_test.rb"
    assert_match(/class AddColumnTitleToPostsMigrationTest/m, contents)
    assert_match(/def test_add_column_title_to_posts_table_schema/m, contents)
    assert_match /assert sql.table_exists\?\(\:posts\)/m,  contents, "assert for table existance"
    assert_match /assert !sql.column_exists\?\(\:posts, \:title\)/m,  contents, "assert for column title existance"
    assert_match(/assert_table :posts/, contents, "assert table not present or wrong table name")
    assert_match(/t.integer\s+:id/, contents, "id column not present")
    assert_match(/t.string\s+:title/, contents, "title column not present")
    assert_match(/def test_add_column_title_to_posts_table_data/m, contents, "wrong method name for test table data")
    assert_match(/_title = 'some data'/m, contents, "no variable _email is present")
    assert_match(/INSERT INTO posts \(id, title, \.\.\., created_at, updated_at\)\s*VALUES \(\\\"\#\{_id\}\\\", \\\"\#\{_title\}\\\", \\\"\#\{\.\.\.\}\\\", \\\"\#\{_created_at\}\\\", \\\"\#\{_updated_at\}\\\"\)/m, contents, "no data being inserted in posts table")
    assert_match(/SELECT \* FROM posts/m, contents, "no data fetched from posts table")
    assert_match(/assert_equal _id, _posts_row\['id'\].to_i/, contents, "assert_equal for id did not match")
    assert_match(/assert_equal _title, _posts_row\['title'\]/, contents, "assert_equal for title did not match")
    assert_match(/assert_equal _created_at, _posts_row\['created_at'\]/, contents, "assert_equal for _created_at did not match")
    assert_match(/assert_equal _updated_at, _posts_row\['updated_at'\]/, contents, "assert_equal for _updated_at did not match")
  end
  def test_add_single_column_with_index
    assert_output /create  test\/migrate\/add_column_title_to_posts_test.rb/m do
      MiniTest::Generators::MigrationGenerator.start ["add_column_title_to_posts", "title:string:index"]
    end
    assert File.exists? "test/migrate/add_column_title_to_posts_test.rb"
    contents = File.read "test/migrate/add_column_title_to_posts_test.rb"
    assert_match(/class AddColumnTitleToPostsMigrationTest/m, contents)
    assert_match(/def test_add_column_title_to_posts_table_schema/m, contents)
    assert_match /assert sql.table_exists\?\(\:posts\)/m,  contents, "assert for table existance"
    assert_match /assert !sql.column_exists\?\(\:posts, \:title\)/m,  contents, "assert for column title existance"
    assert_match(/assert_table :posts/, contents, "assert table not present or wrong table name")
    assert_match(/t.integer\s+:id/, contents, "id column not present")
    assert_match(/t.string\s+:title/, contents, "title column  not present")
    assert_match(/t.index\s+:title,\s+name: 'index_posts_on_title', unique\: false/, contents, "title index not present")
    assert_match(/def test_add_column_title_to_posts_table_data/m, contents, "wrong method name for test table data")
    assert_match(/_title = 'some data'/m, contents, "no variable _email is present")
    assert_match(/INSERT INTO posts \(id, title, \.\.\., created_at, updated_at\)\s*VALUES \(\\\"\#\{_id\}\\\", \\\"\#\{_title\}\\\", \\\"\#\{\.\.\.\}\\\", \\\"\#\{_created_at\}\\\", \\\"\#\{_updated_at\}\\\"\)/m, contents, "no data being inserted in posts table")
    assert_match(/SELECT \* FROM posts/m, contents, "no data fetched from posts table")
    assert_match(/assert_equal _id, _posts_row\['id'\].to_i/, contents, "assert_equal for id did not match")
    assert_match(/assert_equal _title, _posts_row\['title'\]/, contents, "assert_equal for title did not match")
    assert_match(/assert_equal _created_at, _posts_row\['created_at'\]/, contents, "assert_equal for _created_at did not match")
    assert_match(/assert_equal _updated_at, _posts_row\['updated_at'\]/, contents, "assert_equal for _updated_at did not match")
  end
  def test_add_columns_one_with_index
    assert_output /create  test\/migrate\/add_column_title_and_email_to_posts_test.rb/m do
      MiniTest::Generators::MigrationGenerator.start ["add_column_title_and_email_to_posts", "title:string", "email:string:index"]
    end
    assert File.exists? "test/migrate/add_column_title_and_email_to_posts_test.rb"
    contents = File.read "test/migrate/add_column_title_and_email_to_posts_test.rb"
    assert_match(/class AddColumnTitleAndEmailToPostsMigrationTest/m, contents)
    assert_match(/def test_add_column_title_and_email_to_posts_table_schema/m, contents)
    assert_match /assert sql.table_exists\?\(\:posts\)/m,  contents, "assert for table existance"
    assert_match /assert !sql.column_exists\?\(\:posts, \:title\)/m,  contents, "assert for column title existance"
    assert_match(/assert_table :posts/, contents, "assert table not present or wrong table name")
    assert_match(/t.integer\s+:id/, contents, "id column not present")
    assert_match(/t.string\s+:title/, contents, "title column  not present")
    assert_match(/t.string\s+:email/, contents, "title column  not present")
    assert_match(/t.index\s+:email,\s+name: 'index_posts_on_email', unique\: false/, contents, "email index not present")
    assert_match(/def test_add_column_title_and_email_to_posts_table_data/m, contents, "wrong method name for test table data")
    assert_match(/_title = 'some data'/m, contents, "no variable _email is present")
    assert_match(/INSERT INTO posts \(id, title,  email, \.\.\., created_at, updated_at\)\s*VALUES \(\\\"\#\{_id\}\\\", \\\"\#\{_title\}\\\",  \\\"\#\{_email\}\\\", \\\"\#\{\.\.\.\}\\\", \\\"\#\{_created_at\}\\\", \\\"\#\{_updated_at\}\\\"\)/m, contents, "no data being inserted in posts table")
    assert_match(/SELECT \* FROM posts/m, contents, "no data fetched from posts table")
    assert_match(/assert_equal _id, _posts_row\['id'\].to_i/, contents, "assert_equal for id did not match")
    assert_match(/assert_equal _title, _posts_row\['title'\]/, contents, "assert_equal for title did not match")
    assert_match(/assert_equal _email, _posts_row\['email'\]/, contents, "assert_equal for email did not match")
    assert_match(/assert_equal _created_at, _posts_row\['created_at'\]/, contents, "assert_equal for _created_at did not match")
    assert_match(/assert_equal _updated_at, _posts_row\['updated_at'\]/, contents, "assert_equal for _updated_at did not match")
  end
  def test_remove_single_column
    assert_output /create  test\/migrate\/remove_column_title_from_posts_test.rb/m do
      MiniTest::Generators::MigrationGenerator.start ["remove_column_title_from_posts", "title:string"]
    end
    assert File.exists? "test/migrate/remove_column_title_from_posts_test.rb"
    contents = File.read "test/migrate/remove_column_title_from_posts_test.rb"
    assert_match(/class RemoveColumnTitleFromPostsMigrationTest/m, contents)
    assert_match(/def test_remove_column_title_from_posts_table_schema/m, contents)
    assert_match /assert sql.table_exists\?\(\:posts\)/m,  contents, "assert for table existance"
    assert_match /assert sql.column_exists\?\(\:posts, \:title\)/m,  contents, "assert for column title existance"
    assert_match /assert !sql.column_exists\?\(\:posts, \:title\)/m,  contents, "assert for column title existance"
    refute_match(/def test_remove_column_title_from_posts_table_data/m, contents, "method for test table data present")
  end
  def test_remove_columns
    assert_output /create  test\/migrate\/remove_column_title_and_email_from_posts_test.rb/m do
      MiniTest::Generators::MigrationGenerator.start ["remove_column_title_and_email_from_posts", "title:string", "email:string"]
    end
    assert File.exists? "test/migrate/remove_column_title_and_email_from_posts_test.rb"
    contents = File.read "test/migrate/remove_column_title_and_email_from_posts_test.rb"
    assert_match(/class RemoveColumnTitleAndEmailFromPostsMigrationTest/m, contents)
    assert_match(/def test_remove_column_title_and_email_from_posts_table_schema/m, contents)
    assert_match /assert sql.table_exists\?\(\:posts\)/m,  contents, "assert for table existance"
    assert_match /assert sql.column_exists\?\(\:posts, \:title\)/m,  contents, "assert for column title existance"
    assert_match /assert sql.column_exists\?\(\:posts, \:email\)/m,  contents, "assert for column email existance"
    assert_match /assert !sql.column_exists\?\(\:posts, \:title\)/m,  contents, "assert for column title existance"
    assert_match /assert !sql.column_exists\?\(\:posts, \:email\)/m,  contents, "assert for column email existance"
    refute_match(/def test_remove_column_title_and_email_from_posts_table_data/m, contents, "method for test table data present")
  end
  def test_add_timestamps_to_table
    assert_output /create  test\/migrate\/add_timestamps_to_posts_test.rb/m do
      MiniTest::Generators::MigrationGenerator.start ["add_timestamps_to_posts"]
    end
    assert File.exists? "test/migrate/add_timestamps_to_posts_test.rb"
    contents = File.read "test/migrate/add_timestamps_to_posts_test.rb"
    assert_match(/class AddTimestampsToPostsMigrationTest/m, contents)
    assert_match(/def test_add_timestamps_to_posts_table_schema/m, contents)
    assert_match /assert sql.table_exists\?\(\:posts\)/m,  contents, "assert for table existance"
    assert_match /assert sql.column_exists\?\(\:posts, \:created_at\)/m,  contents, "assert for column created_at existance"
    assert_match /assert sql.column_exists\?\(\:posts, \:updated_at\)/m,  contents, "assert for column updated_at existance"
    assert_match /assert !sql.column_exists\?\(\:posts, \:created_at\)/m,  contents, "assert for column created_at existance"
    assert_match /assert !sql.column_exists\?\(\:posts, \:updated_at\)/m,  contents, "assert for column updated_at existance"
    refute_match(/def test_add_timestamps_to_posts_table_data/m, contents, "method for test table data present")
  end
  def test_add_indexes_on_table
    assert_output /create  test\/migrate\/add_indexes_username_and_code_on_posts_test.rb/m do
      MiniTest::Generators::MigrationGenerator.start ["add_indexes_username_and_code_on_posts", "username:uniq", "code"]
    end
    assert File.exists? "test/migrate/add_indexes_username_and_code_on_posts_test.rb"
    contents = File.read "test/migrate/add_indexes_username_and_code_on_posts_test.rb"
    assert_match(/class AddIndexesUsernameAndCodeOnPostsMigrationTest/m, contents)
    assert_match(/def test_add_indexes_username_and_code_on_posts_table_schema/m, contents)
    assert_match /assert sql.table_exists\?\(\:posts\)/m,  contents, "assert for table existance"
    assert_match /assert sql.column_exists\?\(\:posts, \:username\)/m,  contents, "assert for column username existance"
    assert_match /assert !sql.index_exists\?\(\:posts, \:username, unique: true\)/m,  contents, "assert for index username existance"
    assert_match /assert sql.index_exists\?\(\:posts, \:username, unique: true\)/m,  contents, "assert for index username existance"
    assert_match /assert sql.column_exists\?\(\:posts, \:code\)/m,  contents, "assert for column code existance"
    assert_match /assert !sql.index_exists\?\(\:posts, \:code\)/m,  contents, "assert for index code existance"
    assert_match /assert sql.index_exists\?\(\:posts, \:code\)/m,  contents, "assert for index code existance"
    refute_match(/def test_add_timestamps_to_posts_table_data/m, contents, "method for test table data present")
  end
  def test_remove_indexes_on_table
    assert_output /create  test\/migrate\/remove_indexes_username_and_code_on_posts_test.rb/m do
      MiniTest::Generators::MigrationGenerator.start ["remove_indexes_username_and_code_on_posts", "username:uniq", "code"]
    end
    assert File.exists? "test/migrate/remove_indexes_username_and_code_on_posts_test.rb"
    contents = File.read "test/migrate/remove_indexes_username_and_code_on_posts_test.rb"
    assert_match(/class RemoveIndexesUsernameAndCodeOnPostsMigrationTest/m, contents)
    assert_match(/def test_remove_indexes_username_and_code_on_posts_table_schema/m, contents)
    assert_match /assert sql.table_exists\?\(\:posts\)/m,  contents, "assert for table existance"
    assert_match /assert sql.column_exists\?\(\:posts, \:username\)/m,  contents, "assert for column username existance"
    assert_match /assert sql.index_exists\?\(\:posts, \:username, unique: true\)/m,  contents, "assert for index username existance"
    assert_match /assert !sql.index_exists\?\(\:posts, \:username, unique: true\)/m,  contents, "assert for index username existance"
    assert_match /assert sql.column_exists\?\(\:posts, \:code\)/m,  contents, "assert for column code existance"
    assert_match /assert sql.index_exists\?\(\:posts, \:code\)/m,  contents, "assert for index code existance"
    assert_match /assert !sql.index_exists\?\(\:posts, \:code\)/m,  contents, "assert for index code existance"
    refute_match(/def test_remove_timestamps_to_posts_table_data/m, contents, "method for test table data present")
  end
  def test_create_table
    assert_output /create  test\/migrate\/create_users_test.rb/m do
      _generator_options = ["create_users", "company:references", "world:references", "name:string", "email:string:index", "guid:integer:uniq", "admin:boolean"]
      MiniTest::Generators::MigrationGenerator.start _generator_options
    end
    assert File.exists? "test/migrate/create_users_test.rb"
    contents = File.read "test/migrate/create_users_test.rb"
    assert_match(/class CreateUsersMigrationTest/m, contents, "wrong class name")
    assert_match(/def test_create_users_table_schema/m, contents, "wrong method name for test table schema")
    assert_match /assert !sql.table_exists\?\(\:users\)/m,  contents, "assert for table existance"
    assert_match(/assert_table :users/, contents, "assert table not present or wrong table name")
    assert_match(/t.integer\s+:id/, contents, "id column not present")
    assert_match(/t.integer\s+:company_id/, contents, "company_id column not present")
    assert_match(/t.index\s+:company_id, name: 'index_company_id_on_users', unique: false/, contents, "index not present or wrong index options for company_id foreign key")
    assert_match(/t.integer\s+:world_id/, contents, "world_id column not present")
    assert_match(/t.index\s+:world_id, name: 'index_world_id_on_users', unique: false/, contents, "index not present or wrong index options for world_id foreign key")
    assert_match(/t.string\s+:name/, contents, "name column not present")
    assert_match(/t.string\s+:email/, contents, "email column not present")
    assert_match(/t.index\s+:email, name: 'index_email_on_users', unique: false/, contents, "index not present or wrong index options for guid attribute")
    assert_match(/t.integer\s+:guid/, contents, "guid column not present")
    assert_match(/t.index\s+:guid, name: 'index_guid_on_users', unique: true/, contents, "index not present or wrong index options for guid attribute")
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
  def test_create_join_table
    assert_output(/create  test\/migrate\/create_join_table_groups_posts_test.rb/m) do
      MiniTest::Generators::MigrationGenerator.start ["create_join_table_groups_posts", 'group', 'post']
    end
    assert File.exists? "test/migrate/create_join_table_groups_posts_test.rb"
    contents = File.read "test/migrate/create_join_table_groups_posts_test.rb"
    assert_match(/class CreateJoinTableGroupsPostsMigrationTest/m, contents, "wrong class name")
    assert_match(/def test_create_join_table_groups_posts_table_schema/m, contents, "wrong method name for test table schema")
    assert_match /assert !sql.table_exists\?\(\:posts_groups\)/m,  contents, "assert for table existance"
    assert_match(/assert_table :posts_groups/, contents, "assert table not present or wrong table name")
    assert_match(/# t.index\s+\[:post_id, :group_id\], name: 'index_post_id_and_group_id_on_groups_posts', unique: true/, contents, "index for post_id, group_id not present")
    assert_match(/# t.index\s+\[:group_id, :post_id\], name: 'index_group_id_and_post_id_on_groups_posts', unique: true/, contents, "index for group_id, post_id not present")
    assert_match(/def test_create_join_table_groups_posts_table_data/m, contents, "wrong method name for test table data")
    assert_match(/INSERT INTO groups \(id, \.\.\., created_at, updated_at\) VALUES\(\\\"\#\{_id\}\\\", \\\"\#\{\}\\\", \\\"\#\{_created_at\}\\\", \\\"\#\{_updated_at\}\\\"\)/, contents, "no data being inserted in first table")
    assert_match(/INSERT INTO posts \(id, \.\.\., created_at, updated_at\) VALUES\(\\\"\#\{_id\}\\\", \\\"\#\{\}\\\", \\\"\#\{_created_at\}\\\", \\\"\#\{_updated_at\}\\\"\)/, contents, "no data being inserted in second table")
    assert_match(/SELECT groups\.\* FROM groups\s+INNER JOIN posts_groups ON posts_groups\.group_id = groups\.id\s+INNER JOIN posts ON posts_groups\.post_id = posts\.id\s+WHERE groups\.id = \\\"\#\{_group_id\}\\\" AND posts\.id = \\\"\#\{_post_id\}\\\"/, contents, "no data being fetch from tables joins")
    assert_match(/assert_equal _created_at,\s+_posts_groups_row\['created_at'\]/, contents, "assert_equal for _created_at did not match")
    assert_match(/assert_equal _updated_at,\s+_posts_groups_row\['updated_at'\]/, contents, "assert_equal for _updated_at did not match")
  end
  def test_migration_generator_for_class_with_many_names
    assert_output(/create  test\/migrate\/create_product_details_test.rb/m) do
      MiniTest::Generators::MigrationGenerator.start ["create_product_details"]
    end
    assert File.exists? "test/migrate/create_product_details_test.rb"
    contents = File.read "test/migrate/create_product_details_test.rb"
    assert_match(/class CreateProductDetailsMigrationTest/m, contents, "wrong class name")
    assert_match(/def test_create_product_details_table_schema/m, contents, "wrong method name for test table schema")
    assert_match(/assert_table :product_details/, contents, "assert table not present or wrong table name")
    assert_match(/def test_create_product_details_table_data/m, contents, "wrong method name for test table data")
  end
  def test_migration_generator_for_unrecognized_migration
    assert_output(/create  test\/migrate\/this_one_is_not_known_test.rb/m) do
      MiniTest::Generators::MigrationGenerator.start ["this_one_is_not_known"]
    end
    assert File.exists? "test/migrate/this_one_is_not_known_test.rb"
    contents = File.read "test/migrate/this_one_is_not_known_test.rb"
    assert_match /class ThisOneIsNotKnownMigrationTest/m, contents, "wrong class name"
    assert_match /def test_this_one_is_not_known_table_schema/m, contents, "wrong method name for test table schema"
    assert_match /assert_table :table_name/, contents, "assert table not present or wrong table name"
    assert_match /def test_this_one_is_not_known_table_data/m, contents, "wrong method name for test table data"
    assert_match /sql.execute \"INSERT INTO ...\"/, contents, "call to sql insert not present"
    assert_match /sql.select_one \"SELECT \* FROM ...\"/, contents, "call to sql select one not present"
  end
end
