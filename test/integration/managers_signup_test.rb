require 'test_helper'

class ManagersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'Manager.count' do
      post managers_path, manager: { organization: "",
                                     email: "not@valid.com",
                                     password: "test",
                                     password_confirmation: "test2" }
    end
    assert_template 'managers/new'
  end
  
  test "valid signup information" do
    get signup_path
    assert_difference 'Manager.count', 1 do
      post_via_redirect managers_path, manager: { organization: "Example Organization",
                                     email: "now@valid.com",
                                     password: "tester",
                                     password_confirmation: "tester" }
    end
    assert_template 'managers/show'
  end
end