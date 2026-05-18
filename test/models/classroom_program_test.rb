require "test_helper"

class ClassroomProgramTest < ActiveSupport::TestCase
  setup do
    @classroom_program = classroom_programs(:one)
    @classroom_program.classroom_modules.destroy_all
  end

  test "generate_modules! creates a ClassroomModule for each matching content module" do
    assert_difference "ClassroomModule.count", 1 do
      @classroom_program.generate_modules!
    end
  end

  test "generate_modules! is idempotent" do
    @classroom_program.generate_modules!

    assert_no_difference "ClassroomModule.count" do
      @classroom_program.generate_modules!
    end
  end

  test "generate_modules! prunes modules that no longer match after a level change" do
    @classroom_program.generate_modules!
    original_count = @classroom_program.classroom_modules.count

    @classroom_program.update!(level: "advanced")
    @classroom_program.generate_modules!

    assert_not_equal original_count, @classroom_program.classroom_modules.reload.count
    assert @classroom_program.classroom_modules.none? { |m| m.content_module.level == "basic" }
  end

  test "is invalid when changing level that has modules with publish dates" do
    @classroom_program.generate_modules!
    @classroom_program.classroom_modules.first.update!(publish_on: Date.current)

    @classroom_program.level = "advanced"
    assert_not @classroom_program.valid?
    assert_includes @classroom_program.errors[:level], "cannot be changed when modules have publish dates set"
  end

  test "is valid when changing level that has no modules with publish dates" do
    @classroom_program.generate_modules!

    @classroom_program.level = "advanced"
    assert @classroom_program.valid?
  end
end
