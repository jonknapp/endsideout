require "test_helper"

class StudentHomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student = students(:ada)
    student_sign_in_as @student
  end

  test "unauthenticated request redirects to student login" do
    student_sign_out
    get student_homes_url
    assert_redirected_to new_student_session_url
  end

  test "shows published module names" do
    get student_homes_url
    assert_response :success
    assert_select "summary", text: /Introduction to Health/
  end

  test "shows links inside published modules" do
    get student_homes_url
    assert_response :success
    link = content_modules(:intro).links.first
    assert_select "a[target='_blank']", text: /#{link.title}/ if link
  end

  test "most recently published module has the open attribute" do
    # Add a second published module so there's a distinct "most recent"
    second_module = ContentModule.create!(
      program: programs(:kyh), level: "basic", name: "Second Module", position: 2
    )
    classroom_programs(:one).classroom_modules.create!(
      content_module: second_module, publish_on: Date.current
    )

    get student_homes_url
    assert_select "details[open] summary", text: /Second Module/
  end

  test "all modules published on the same latest date have the open attribute" do
    second_module = ContentModule.create!(
      program: programs(:kyh), level: "basic", name: "Second Module", position: 2
    )
    classroom_modules(:one).update!(publish_on: Date.current)
    classroom_programs(:one).classroom_modules.create!(
      content_module: second_module, publish_on: Date.current
    )

    get student_homes_url
    assert_select "details[open]", count: 2
  end

  test "shows empty state when no modules are published" do
    classroom_modules(:one).update!(publish_on: nil)
    get student_homes_url
    assert_select "p", text: /No modules published yet/
  end

  test "does not show tab bar for single program enrollment" do
    get student_homes_url
    assert_select "[role='tablist']", count: 0
  end

  test "shows tab bar when classroom has multiple program enrollments" do
    classroom_programs(:one).classroom.classroom_programs.create!(
      program: programs(:"3dw"), level: "moderate"
    )

    get student_homes_url
    assert_select "[role='tablist']"
    assert_select "a[role='tab']", minimum: 2
  end

  test "tab switching shows the selected program as active" do
    enrollment = classroom_programs(:one)
    enrollment.classroom.classroom_programs.create!(program: programs(:"3dw"), level: "moderate")

    get student_homes_url(classroom_program_id: enrollment.id)
    assert_select "a[role='tab'][aria-selected='true'][href*='classroom_program_id=#{enrollment.id}']"
  end
end
