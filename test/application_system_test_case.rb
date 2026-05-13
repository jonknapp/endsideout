require "test_helper"
require "axe-capybara"
require "axe/matchers/be_axe_clean"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_firefox, screen_size: [ 1400, 1400 ]

  def assert_accessible
    matcher = Axe::Matchers::BeAxeClean.new
    audit = matcher.audit(page)
    assert audit.passed?, audit.failure_message
  end
end
