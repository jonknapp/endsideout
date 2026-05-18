require "test_helper"

class ClassroomModulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @classroom_module = classroom_modules(:one)
    sign_in_as users(:admin)
  end

  test "update sets publish_on and responds with turbo stream" do
    patch classroom_module_url(@classroom_module),
      params: { classroom_module: { publish_on: "2026-06-01" } },
      headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :success
    assert_equal "2026-06-01", @classroom_module.reload.publish_on.to_s
  end

  test "update clears publish_on when blank" do
    @classroom_module.update!(publish_on: Date.current)

    patch classroom_module_url(@classroom_module),
      params: { classroom_module: { publish_on: "" } },
      headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :success
    assert_nil @classroom_module.reload.publish_on
  end

  test "update HTML fallback redirects to the schedule page" do
    patch classroom_module_url(@classroom_module),
      params: { classroom_module: { publish_on: "2026-06-01" } }

    assert_redirected_to schedule_classroom_url(@classroom_module.classroom_program.classroom)
  end
end
