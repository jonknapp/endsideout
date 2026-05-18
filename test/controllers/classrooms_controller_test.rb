require "test_helper"

class ClassroomsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @classroom = classrooms(:one)
    sign_in_as users(:admin)
  end

  test "should get edit" do
    get edit_classroom_url(@classroom)
    assert_response :success
  end

  test "should update classroom name and teacher" do
    patch classroom_url(@classroom), params: { classroom: { name: "Updated Name", teacher: "New Teacher" } }
    assert_redirected_to school_students_url(@classroom.school)
    assert_equal "Updated Name", @classroom.reload.name
  end

  test "should add a program enrollment" do
    program = programs(:"3dw")

    assert_difference "ClassroomProgram.count" do
      patch classroom_url(@classroom), params: {
        classroom: {
          name: @classroom.name,
          classroom_programs_attributes: [ { program_id: program.id, level: "moderate" } ]
        }
      }
    end

    assert_redirected_to school_students_url(@classroom.school)
    assert @classroom.classroom_programs.exists?(program: program, level: "moderate")
  end

  test "should update an existing enrollment level" do
    enrollment = classroom_programs(:one)
    enrollment.classroom_modules.update_all(publish_on: nil)

    patch classroom_url(@classroom), params: {
      classroom: {
        name: @classroom.name,
        classroom_programs_attributes: [ { id: enrollment.id, program_id: enrollment.program_id, level: "advanced" } ]
      }
    }

    assert_redirected_to school_students_url(@classroom.school)
    assert_equal "advanced", enrollment.reload.level
  end

  test "should remove an enrollment" do
    enrollment = classroom_programs(:one)
    @classroom.classroom_programs.create!(program: programs(:"3dw"), level: "basic")

    assert_difference "ClassroomProgram.count", -1 do
      patch classroom_url(@classroom), params: {
        classroom: {
          name: @classroom.name,
          classroom_programs_attributes: [ { id: enrollment.id, _destroy: "1" } ]
        }
      }
    end

    assert_redirected_to school_students_url(@classroom.school)
  end

  test "is invalid when removing all programs" do
    enrollment = @classroom.classroom_programs.first!

    assert_no_difference "ClassroomProgram.count" do
      patch classroom_url(@classroom), params: {
        classroom: {
          name: @classroom.name,
          classroom_programs_attributes: [ { id: enrollment.id, _destroy: "1" } ]
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "is invalid when a program is selected without a level" do
    program = programs(:"3dw")

    assert_no_difference "ClassroomProgram.count" do
      patch classroom_url(@classroom), params: {
        classroom: {
          name: @classroom.name,
          classroom_programs_attributes: [ { program_id: program.id, level: "" } ]
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "generates modules when a new enrollment is added" do
    program = programs(:"3dw")

    assert_difference "ClassroomModule.count" do
      patch classroom_url(@classroom), params: {
        classroom: {
          name: @classroom.name,
          classroom_programs_attributes: [ { program_id: program.id, level: "moderate" } ]
        }
      }
    end

    cp = @classroom.classroom_programs.find_by!(program: program)
    assert cp.classroom_modules.exists?(content_module: content_modules(:moderate_wellness))
  end

  test "is invalid when changing a level that has scheduled modules" do
    enrollment = classroom_programs(:one)
    enrollment.generate_modules!
    enrollment.classroom_modules.first.update!(publish_on: Date.current)

    patch classroom_url(@classroom), params: {
      classroom: {
        name: @classroom.name,
        classroom_programs_attributes: [ { id: enrollment.id, program_id: enrollment.program_id, level: "advanced" } ]
      }
    }

    assert_response :unprocessable_entity
    assert_equal "basic", enrollment.reload.level
  end

  test "should get schedule" do
    get schedule_classroom_url(@classroom)
    assert_response :success
  end

  test "schedule marks the first enrollment tab as selected by default" do
    first_enrollment = @classroom.classroom_programs.includes(:program).order("programs.name").first
    get schedule_classroom_url(@classroom)
    assert_select "a[role='tab'][aria-selected='true'][href*='classroom_program_id=#{first_enrollment.id}']"
  end

  test "schedule marks the requested enrollment tab as selected" do
    enrollment = classroom_programs(:one)
    get schedule_classroom_url(@classroom, classroom_program_id: enrollment.id)
    assert_select "a[role='tab'][aria-selected='true'][href*='classroom_program_id=#{enrollment.id}']"
  end
end
