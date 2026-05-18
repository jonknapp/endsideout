require "test_helper"

class ContentModuleTest < ActiveSupport::TestCase
  setup do
    @program = programs(:kyh)
  end

  test "is valid with required fields" do
    content_module = ContentModule.new(program: @program, level: "basic", name: "Test Module")
    assert content_module.valid?
  end

  test "is invalid without a name" do
    content_module = ContentModule.new(program: @program, level: "basic")
    assert_not content_module.valid?
    assert_includes content_module.errors[:name], "can't be blank"
  end

  test "is invalid without a level" do
    content_module = ContentModule.new(program: @program, name: "Test Module")
    assert_not content_module.valid?
  end

  test "is invalid without a program" do
    content_module = ContentModule.new(level: "basic", name: "Test Module")
    assert_not content_module.valid?
  end

  test "destroys associated links" do
    content_module = ContentModule.create!(program: @program, level: "basic", name: "With Links")
    content_module.links.create!(title: "A Link", url: "https://example.com", link_type: "survey")

    assert_difference "Link.count", -1 do
      content_module.destroy!
    end
  end

  test "cannot be destroyed when classroom modules exist" do
    content_module = ContentModule.create!(program: @program, level: "basic", name: "Assigned Module")
    classroom_program = classroom_programs(:one)
    classroom_program.classroom_modules.create!(content_module: content_module)

    assert_not content_module.destroy
    assert content_module.persisted?
  end
end
