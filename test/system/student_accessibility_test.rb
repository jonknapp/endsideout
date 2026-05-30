require "application_system_test_case"

class StudentAccessibilityTest < ApplicationSystemTestCase
  test "student can login from classroom roster and home page is accessible" do
    student = students(:ada)
    classroom = classrooms(:one)

    # Visit classroom roster
    visit classroom_roster_path(uuid: classroom.uuid)

    # Check accessibility of the roster page
    assert_accessible

    # Login as student by clicking their name
    click_on student.full_name

    # Verify we are on the student home page
    assert_selector "h1", text: "Welcome, #{student.first_name}!"

    # Check accessibility of the home page
    assert_accessible
  end
end
