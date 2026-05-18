require "test_helper"

class ClassroomTest < ActiveSupport::TestCase
  test "creates enrollment via nested attributes" do
    classroom = classrooms(:one)
    program = programs(:"3dw")

    assert_difference "ClassroomProgram.count" do
      classroom.update!(
        classroom_programs_attributes: [ { program_id: program.id, level: "advanced" } ]
      )
    end

    assert classroom.classroom_programs.exists?(program: program, level: "advanced")
  end

  test "updates level via nested attributes" do
    classroom = classrooms(:one)
    enrollment = classroom_programs(:one)
    enrollment.classroom_modules.update_all(publish_on: nil)

    classroom.update!(
      classroom_programs_attributes: [ { id: enrollment.id, program_id: enrollment.program_id, level: "advanced" } ]
    )

    assert_equal "advanced", enrollment.reload.level
  end

  test "destroys enrollment via nested attributes" do
    classroom = classrooms(:one)
    enrollment = classroom_programs(:one)

    # Add a second enrollment first so the classroom still has one after destruction
    classroom.classroom_programs.create!(program: programs(:"3dw"), level: "basic")

    assert_difference "ClassroomProgram.count", -1 do
      classroom.update!(
        classroom_programs_attributes: [ { id: enrollment.id, _destroy: "1" } ]
      )
    end
  end

  test "rejects new enrollment when checkbox is unchecked (_destroy: 1)" do
    classroom = classrooms(:one)
    program = programs(:"3dw")

    assert_no_difference "ClassroomProgram.count" do
      classroom.update!(
        classroom_programs_attributes: [ { program_id: program.id, level: "basic", _destroy: "1" } ]
      )
    end
  end

  test "is invalid when a new enrollment has no level selected" do
    classroom = classrooms(:one)
    program = programs(:"3dw")

    classroom.assign_attributes(
      classroom_programs_attributes: [ { program_id: program.id, level: "" } ]
    )

    assert_not classroom.valid?
    assert classroom.errors.any? { |e| e.attribute.to_s.include?("classroom_programs") }
  end

  test "is invalid when all programs are removed" do
    classroom = classrooms(:one)
    enrollment = classroom_programs(:one)

    classroom.assign_attributes(
      classroom_programs_attributes: [ { id: enrollment.id, _destroy: "1" } ]
    )

    assert_not classroom.valid?
    assert_includes classroom.errors[:base], "must have at least one program enrolled"
  end
end
