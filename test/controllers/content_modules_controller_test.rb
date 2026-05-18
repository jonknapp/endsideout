require "test_helper"

class ContentModulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @content_module = content_modules(:intro)
    sign_in_as users(:admin)
  end

  test "should get index" do
    get content_modules_url
    assert_response :success
  end

  test "index marks the active program tab as selected" do
    program = programs(:kyh)
    get content_modules_url(program_id: program.id)
    assert_select "a[role='tab'][aria-selected='true'][href*='program_id=#{program.id}']"
  end

  test "should get new" do
    get new_content_module_url
    assert_response :success
  end

  test "should create content module" do
    assert_difference "ContentModule.count" do
      post content_modules_url, params: {
        content_module: { name: "New Module", program_id: programs(:kyh).id, level: "moderate", position: 1 }
      }
    end
    assert_redirected_to content_modules_url
  end

  test "should not create with missing name" do
    assert_no_difference "ContentModule.count" do
      post content_modules_url, params: {
        content_module: { name: "", program_id: programs(:kyh).id, level: "basic" }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_content_module_url(@content_module)
    assert_response :success
  end

  test "should update content module" do
    patch content_module_url(@content_module), params: {
      content_module: { name: "Updated Name" }
    }
    assert_redirected_to content_modules_url
    assert_equal "Updated Name", @content_module.reload.name
  end

  test "should destroy content module" do
    content_module = ContentModule.create!(program: programs(:kyh), level: "basic", name: "To Delete")
    assert_difference "ContentModule.count", -1 do
      delete content_module_url(content_module)
    end
    assert_redirected_to content_modules_url
  end

  test "should not destroy content module assigned to classrooms" do
    assert_no_difference "ContentModule.count" do
      delete content_module_url(@content_module)
    end
    assert_redirected_to content_modules_url
    assert_equal "Cannot delete a module that has been assigned to classrooms.", flash[:alert]
  end
end
