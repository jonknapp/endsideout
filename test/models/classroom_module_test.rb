require "test_helper"

class ClassroomModuleTest < ActiveSupport::TestCase
  setup do
    @cm = classroom_modules(:one)
  end

  test "published scope excludes modules with no publish_on" do
    @cm.update!(publish_on: nil)
    assert_not_includes ClassroomModule.published, @cm
  end

  test "published scope includes modules with publish_on today" do
    @cm.update!(publish_on: Date.current)
    assert_includes ClassroomModule.published, @cm
  end

  test "published scope includes modules with publish_on in the past" do
    @cm.update!(publish_on: Date.current - 1)
    assert_includes ClassroomModule.published, @cm
  end

  test "published scope excludes modules with publish_on in the future" do
    @cm.update!(publish_on: Date.current + 1)
    assert_not_includes ClassroomModule.published, @cm
  end
end
