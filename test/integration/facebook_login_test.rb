require 'test_helper'
require 'integration/integration_helper_test'

class FacebookLoginTest < ActionDispatch::IntegrationTest
  include IntegrationHelperTest

  def setup
    @user1 = User.create(email: 'kmc3@williams.edu', password: 'foobar', name: 'Kevin Chen', first_name: 'Kevin', last_name: 'Chen')
  end

  test "should create new account if no email is found" do
    post '/facebooklogin.json', { 
      email: 'new@gmail.com', 
      first_name: 'New', 
      last_name: 'Guy', 
      username: 'NewGuy' 
    }
    assert_equal true, json['success']
    assert_equal 'user_created', json['status']
    assert_not_nil json['user']
    assert_not_nil json['api_key']
  end

  test "should create FB identity for existing user" do
    post '/facebooklogin.json', { 
      email: @user1.email, 
      first_name: @user1.first_name, 
      last_name: @user1.last_name, 
      username: "#{@user1.first_name} #{@user1.first_name}"
    }
    assert_equal true, json['success']
    assert_equal 'user_exists', json['status']
    assert_not_nil json['user']
    assert_not_nil json['api_key']
  end

  test "should supply an email" do
    post '/facebooklogin.json', { 
      first_name: @user1.first_name, 
      last_name: @user1.last_name, 
      username: "#{@user1.first_name} #{@user1.first_name}"
    }
    assert_equal false, json['success']
    assert_equal 'no_email_supplied', json['status']
  end

end
