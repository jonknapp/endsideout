require "test_helper"

class TeacherTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "is valid with a name and school" do
    teacher = Teacher.new(name: "Ms. Frizzle", school: schools(:one))

    assert teacher.valid?
  end

  test "requires a name" do
    teacher = Teacher.new(name: nil, school: schools(:one))

    assert_not teacher.valid?
    assert_includes teacher.errors[:name], "can't be blank"
  end

  test "has many classrooms" do
    association = Teacher.reflect_on_association(:classrooms)

    assert_not_nil association
    assert_equal :has_many, association.macro
  end

  test "destroying a teacher clears classroom assignments" do
    teacher = teachers(:one)
    classroom = classrooms(:one)

    assert_equal teacher, classroom.teacher

    assert_difference("Teacher.count", -1) do
      teacher.destroy
    end

    assert_nil classroom.reload.teacher
  end
end
