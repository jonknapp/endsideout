require "test_helper"

class ClassroomRostersControllerTest < ActionDispatch::IntegrationTest
  test "should get show without signing in" do
    classroom = classrooms(:one)
    get classroom_roster_url(classroom.uuid)
    assert_response :success
  end
end
