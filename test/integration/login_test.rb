require 'test_helper'
require 'integration/integration_helper_test'

class LoginTest < ActionDispatch::IntegrationTest
  include IntegrationHelperTest

  def setup
    @user1 = User.create(email: 'kmc3@williams.edu', password: 'foobar', name: 'Kevin Chen', first_name: 'Kevin', last_name: 'Chen')
  end

  test "should login with email and password" do
    post '/login.json', { email: @user1.email, password: @user1.password }
    assert_equal @user1.api_key.access_token, json['api_key']['access_token']
  end

  test "should login with valid email" do
    junkEmail = 'junkEmail'
    post '/login.json', { email: junkEmail, password: 'foobar' }
    assert_equal false, json['success']
    assert_equal 'invalid_email', json['status']
  end

  test "should login with valid password" do
    post '/login.json', { email: @user1.email, password: 'junkPassword' }
    assert_equal false, json['success']
    assert_equal 'invalid_password', json['status']
  end

end
