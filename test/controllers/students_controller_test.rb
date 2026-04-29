require "test_helper"

class StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @school = schools(:one)
    @student = students(:ada)
    sign_in_as users(:admin)
  end

  test "should get index" do
    get school_students_url(@school)
    assert_response :success
  end

  test "should get new" do
    get new_school_student_url(@school)
    assert_response :success
  end

  test "should create student" do
    assert_difference("Student.count") do
      post school_students_url(@school), params: { student: { email: @student.email, first_name: @student.first_name, gender: @student.gender, grade_level: @student.grade_level, last_name: @student.last_name, classroom_id: @student.classroom_id } }
    end

    assert_redirected_to student_url(Student.last)
  end

  test "should show student" do
    get student_url(@student)
    assert_response :success
  end

  test "should get edit" do
    get edit_student_url(@student)
    assert_response :success
  end

  test "should update student" do
    patch student_url(@student), params: { student: { email: @student.email, first_name: @student.first_name, gender: @student.gender, grade_level: @student.grade_level, last_name: @student.last_name, school_id: @student.school_id } }
    assert_redirected_to student_url(@student)
  end

  test "can update a student's classroom" do
    classroom = @student.classroom.dup
    classroom.update! uuid: SecureRandom.urlsafe_base64(32), name: "New Classroom"
    assert_changes -> { @student.reload.classroom_id } do
      patch student_url(@student), params: { student: { classroom_id: classroom.id } }
      assert_redirected_to student_url(@student)
    end
  end

  test "should destroy student" do
    assert_difference("Student.count", -1) do
      delete student_url(@student)
    end

    assert_redirected_to school_students_url(@school)
  end
end
