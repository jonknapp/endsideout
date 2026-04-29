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

  test "should update classroom" do
    sign_in_as users(:admin)
    patch classroom_url(@classroom), params: { classroom: { name: @classroom.name, teacher: @classroom.teacher } }
    assert_redirected_to school_students_url(@classroom.school)
  end
end
