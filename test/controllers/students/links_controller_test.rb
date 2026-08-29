require "test_helper"

class Students::LinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student = students(:ada)
    student_sign_in_as @student
    @survey = links(:survey_one)
    @game = links(:game_one)
  end

  test "unauthenticated request redirects to student login" do
    student_sign_out
    get students_link_url(@survey)
    assert_redirected_to new_student_session_url
  end

  test "shows survey page with iframe" do
    get students_link_url(@survey)
    assert_response :success
    assert_select "iframe[src='#{@survey.url}']"
  end

  test "shows game page with iframe" do
    get students_link_url(@game)
    assert_response :success
    assert_select "iframe[src='#{@game.url}']"
  end

  test "shows link type badge" do
    get students_link_url(@survey)
    assert_select ".badge", text: /survey/i
  end

  test "raises not found for link outside student classroom" do
    other_link = links(:game_one)
    student_sign_out
    student_sign_in_as students(:grace)  # grace is in classroom two, which has a different program

    get students_link_url(other_link)
    assert_response :not_found
  end
end
