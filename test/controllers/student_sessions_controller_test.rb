require "test_helper"

class StudentSessionsControllerTest < ActionDispatch::IntegrationTest
    setup { @student = students(:ada) }

    test "new" do
      get new_student_session_path
      assert_response :success
    end

    test "create with valid classroom" do
      post student_session_path, params: { student_id: @student.id, classroom_uuid: @student.classroom.uuid }

      assert_redirected_to student_homes_path
      assert cookies[:student_session_id]
    end

    test "create with invalid uuid" do
      post student_session_path, params: { student_id: @student.id, classroom_uuid: "wrong" }

      assert_redirected_to new_student_session_path
      assert_nil cookies[:student_session_id]
    end

    test "create with wrong classroom uuid" do
      other_classroom = classrooms(:two)
      assert_not @student.classroom_id == other_classroom.id
      post student_session_path, params: { student_id: @student.id, classroom_uuid: other_classroom.uuid }

      assert_redirected_to new_student_session_path
      assert_nil cookies[:student_session_id]
    end

    test "destroy" do
      student_sign_in_as(@student)

      delete student_session_path

      assert_redirected_to new_student_session_path
      assert_empty cookies[:student_session_id]
    end
end
