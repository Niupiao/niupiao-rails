require 'test_helper'

# Tests here are to work with page structure/basic elements of individual pages.

class BasicStructureTest < ActionDispatch::IntegrationTest

  test "layout links on home" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", static_pages_about_path
  end
end