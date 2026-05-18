require "test_helper"

class LinkTest < ActiveSupport::TestCase
  test "is valid with required fields" do
    link = Link.new(content_module: content_modules(:intro), title: "My Link", url: "https://example.com", link_type: "survey")
    assert link.valid?
  end

  test "is invalid without a title" do
    link = Link.new(content_module: content_modules(:intro), url: "https://example.com", link_type: "survey")
    assert_not link.valid?
    assert_includes link.errors[:title], "can't be blank"
  end

  test "is invalid without a url" do
    link = Link.new(content_module: content_modules(:intro), title: "My Link", link_type: "survey")
    assert_not link.valid?
    assert_includes link.errors[:url], "can't be blank"
  end

  test "is invalid without a link_type" do
    link = Link.new(content_module: content_modules(:intro), title: "My Link", url: "https://example.com")
    assert_not link.valid?
  end
end
