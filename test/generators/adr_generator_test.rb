require "test_helper"
require "rails/generators/testing/behavior"
require "rails/generators/testing/assertions"
require "generators/adr/adr_generator"

class ADRGeneratorTest < Rails::Generators::TestCase
  tests AdrGenerator
  destination Rails.root.join("tmp/generator_tests")

  setup do
    self.destination_root = Rails.root.join("tmp", "generator_tests_#{Process.pid}")
    prepare_destination
  end

  test "creates adr file with sequential number" do
    run_generator [ "use_postgres_as_primary_database" ]
    assert_file "docs/adrs/0001_use_postgres_as_primary_database.md"
  end

  test "normalizes kebab-case input" do
    run_generator [ "use-postgres-as-primary-database" ]
    assert_file "docs/adrs/0001_use_postgres_as_primary_database.md"
  end

  test "normalizes CamelCase input" do
    run_generator [ "UsePostgresAsPrimaryDatabase" ]
    assert_file "docs/adrs/0001_use_postgres_as_primary_database.md"
  end

  test "normalizes spaces input" do
    run_generator [ "Use Postgres As Primary Database" ]
    assert_file "docs/adrs/0001_use_postgres_as_primary_database.md"
  end

  test "increments number based on existing adrs" do
    FileUtils.mkdir_p(File.join(destination_root, "docs/adrs"))
    FileUtils.touch(File.join(destination_root, "docs/adrs/0001_existing_decision.md"))
    run_generator [ "second_decision" ]
    assert_file "docs/adrs/0002_second_decision.md"
  end

  test "populates template with title and date" do
    run_generator [ "use_postgres_as_primary_database" ]
    assert_file "docs/adrs/0001_use_postgres_as_primary_database.md" do |content|
      assert_match "# 0001. Use Postgres As Primary Database", content
      assert_match Date.today.strftime("%Y-%m-%d"), content
      assert_match "## Context", content
      assert_match "## Decision", content
      assert_match "## Consequences", content
    end
  end

  test "title number matches filename number" do
    FileUtils.mkdir_p(File.join(destination_root, "docs/adrs"))
    FileUtils.touch(File.join(destination_root, "docs/adrs/0001_existing_decision.md"))
    run_generator [ "second_decision" ]
    assert_file "docs/adrs/0002_second_decision.md" do |content|
      assert_match "# 0002.", content
    end
  end
end
