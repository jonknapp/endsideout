require "test_helper"

class TeachersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @school = schools(:one)
    sign_in_as users(:admin)
  end

  test "should get index" do
    get school_teachers_url(@school)
    assert_response :success
  end

  test "should get new" do
    get new_school_teacher_url(@school)
    assert_response :success
  end
  test "should create teacher" do
    assert_difference("Teacher.count") do
      post school_teachers_url(@school), params: {
        teacher: {
          name: "Ms. Frizzle",
          email: "frizzle@example.com"
        }
      }
    end

    assert_redirected_to teacher_url(Teacher.last)
  end

  test "should show teacher" do
    teacher = teachers(:one)

    get teacher_url(teacher)
    assert_response :success
  end

  test "should get edit" do
    teacher = teachers(:one)

    get edit_teacher_url(teacher)
    assert_response :success
  end

  test "should update teacher" do
    teacher = teachers(:one)

    patch teacher_url(teacher), params: {
      teacher: {
        name: "Updated Teacher",
        email: "updated@example.com"
      }
    }

    assert_redirected_to teacher_url(teacher)
    assert_equal "Updated Teacher", teacher.reload.name
  end

  test "should destroy teacher" do
    teacher = teachers(:one)

    assert_difference("Teacher.count", -1) do
      delete teacher_url(teacher)
    end

    assert_redirected_to school_teachers_url(teacher.school)
  end

  test "should not create teacher without a name" do
    assert_no_difference("Teacher.count") do
      post school_teachers_url(@school), params: {
        teacher: {
          name: "",
          email: "teacher@example.com"
        }
      }
    end

    assert_response :unprocessable_entity
  end
  test "should not update teacher without a name" do
    teacher = teachers(:one)

    patch teacher_url(teacher), params: {
      teacher: {
        name: "",
        email: teacher.email
      }
    }

    assert_response :unprocessable_entity
  end

  test "should create teacher with classroom assignments" do
    classroom = classrooms(:one)

    assert_difference("Teacher.count") do
      post school_teachers_url(@school), params: {
        teacher: {
          name: "Ms. Frizzle",
          email: "frizzle@example.com",
          classroom_ids: [ classroom.id ]
        }
      }
    end

    teacher = Teacher.last

    assert_redirected_to teacher_url(teacher)
    assert_equal [ classroom.id ], teacher.classrooms.reload.pluck(:id)
  end

  test "should update teacher classroom assignments" do
    teacher = teachers(:two)
    classroom = classrooms(:two)

    patch teacher_url(teacher), params: {
      teacher: {
        name: teacher.name,
        email: teacher.email,
        classroom_ids: [ classroom.id ]
      }
    }

    assert_redirected_to teacher_url(teacher)
    assert_equal [ classroom.id ], teacher.classrooms.reload.pluck(:id)
  end

  test "should clear teacher classroom assignments when none are selected" do
    teacher = teachers(:one)
    classroom = classrooms(:one)

    assert_equal teacher, classroom.teacher

    patch teacher_url(teacher), params: {
      teacher: {
        name: teacher.name,
        email: teacher.email,
        classroom_ids: []
      }
    }

    assert_redirected_to teacher_url(teacher)
    assert_empty teacher.classrooms.reload
    assert_nil classroom.reload.teacher
  end

  test "should reassign a classroom to another teacher" do
    original_teacher = teachers(:one)
    new_teacher = Teacher.create!(name: "Teacher 3", school: schools(:one))
    classroom = classrooms(:one)

    assert_equal original_teacher, classroom.teacher

    patch teacher_url(new_teacher), params: {
      teacher: {
        name: new_teacher.name,
        email: new_teacher.email,
        classroom_ids: [ classroom.id ]
      }
    }

    assert_redirected_to teacher_url(new_teacher)
    assert_equal new_teacher, classroom.reload.teacher
    assert_empty original_teacher.classrooms.reload
    assert_equal [ classroom.id ], new_teacher.classrooms.reload.pluck(:id)
  end

  test "should not assign a classroom from another school" do
    teacher = teachers(:one)
    other_school_classroom = classrooms(:two)

    patch teacher_url(teacher), params: {
      teacher: {
        name: teacher.name,
        email: teacher.email,
        classroom_ids: [ other_school_classroom.id ]
      }
    }

    assert_response :unprocessable_entity
    assert_nil other_school_classroom.reload.teacher
    assert_equal [ classrooms(:one).id ], teacher.classrooms.reload.pluck(:id)
  end

  test "edit shows classrooms for the teacher's school" do
    teacher = teachers(:one)
    classroom = classrooms(:one)

    get edit_teacher_url(teacher)

    assert_response :success
    assert_match classroom.name, response.body
  end

  test "index shows teachers and their classrooms" do
    teacher = teachers(:one)
    classroom = classrooms(:one)

    get school_teachers_url(@school)

    assert_response :success
    assert_match teacher.name, response.body
    assert_match classroom.name, response.body
  end

  test "show displays teacher details and classrooms" do
    teacher = teachers(:one)
    classroom = classrooms(:one)

    get teacher_url(teacher)

    assert_response :success
    assert_match teacher.name, response.body
    assert_match classroom.name, response.body
  end
end
