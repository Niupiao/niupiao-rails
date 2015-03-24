require 'test_helper'

class FacebookIdentityTest < ActiveSupport::TestCase

  def setup
    @birthday = '4/17/1993'
    @first_name = 'Kevin'
    @last_name = 'Chen'
    @name = 'Kevin Chen'
    @username = 'KevChenKev'
    @location = 'Williamstown, MA'
    @link = 'https://www.github.com/kevinchen93'
    @facebook_id = 1
    @user = User.create(email: @email, password: @password)
  end

  test "needs to bind to a user" do
    assert FacebookIdentity.create do |f|
      
    end
  end
end
