require "helper"
require "generators/mini_test/install/install_generator"

class TestInstallGenerator < GeneratorTest

  def test_assert_test_helper_is_installed
    assert_output(/create  test\/test_helper.rb/m) do
      MiniTest::Generators::InstallGenerator.start
    end
  end

  def test_assert_migration_test_helper_exists
    assert_output(/create  test\/test_helper.rb/m) do
      MiniTest::Generators::InstallGenerator.start
    end
    assert File.exists?("test/migration_test_helpers.rb"), "migration test helper does not exist"
  end

  def test_assert_output_is_rendered_on_install
    assert_output(/create  test\/test_helper.rb/m) do
      MiniTest::Generators::InstallGenerator.start
    end
  end

  def test_assert_test_helper_exists
    assert_output(/create  test\/test_helper.rb/m) do
      MiniTest::Generators::InstallGenerator.start
    end
    assert File.exists?("test/test_helper.rb"), "test helper file does not exist"
  end

  def test_assert_test_helper_requires_rails_test_help
    assert_output(/create  test\/test_helper.rb/m) do
      MiniTest::Generators::InstallGenerator.start
    end
    contents = File.read "test/test_helper.rb"
    assert_match(/require "rails\/test_help"/m, contents)
  end

  def test_assert_test_helper_requires_minitest_rails
    assert_output(/create  test\/test_helper.rb/m) do
      MiniTest::Generators::InstallGenerator.start
    end
    contents = File.read "test/test_helper.rb"
    assert_match(/require "minitest\/rails"/m, contents)
  end

end
