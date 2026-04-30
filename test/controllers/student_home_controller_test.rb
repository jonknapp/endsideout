require "test_helper"

class StudentHomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    student_sign_in_as(students(:ada))

    get student_homes_path
    assert_response :success
  end

  test "should redirect to new session if not signed in" do
    get student_homes_path
    assert_redirected_to new_student_session_path
  end
end
