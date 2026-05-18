require "test_helper"

class LinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @link = links(:survey_one)
    @mod = content_modules(:intro)
    sign_in_as users(:admin)
  end

  test "should get new" do
    get new_content_module_link_url(@mod)
    assert_response :success
  end

  test "should create link" do
    assert_difference "Link.count" do
      post content_module_links_url(@mod), params: {
        link: { title: "New Survey", url: "https://example.com/new", link_type: "survey", position: 3 }
      }
    end
    assert_redirected_to edit_content_module_url(@mod)
  end

  test "should not create with missing title" do
    assert_no_difference "Link.count" do
      post content_module_links_url(@mod), params: {
        link: { title: "", url: "https://example.com", link_type: "survey" }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_link_url(@link)
    assert_response :success
  end

  test "should update link" do
    patch link_url(@link), params: { link: { title: "Updated Title" } }
    assert_redirected_to edit_content_module_url(@mod)
    assert_equal "Updated Title", @link.reload.title
  end

  test "should destroy link" do
    assert_difference "Link.count", -1 do
      delete link_url(@link)
    end
    assert_redirected_to edit_content_module_url(@mod)
  end
end
