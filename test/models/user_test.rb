require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @email = 'bob@gmail.com'
    @password = 'foobar'
  end

  test "should have email and password" do
    assert_not User.create(email: @email).valid?
    assert_not User.create(password: @password).valid?
    assert User.create(email: @email, password: @password).valid?
  end

  test "should have sufficiently long password" do
    assert_not User.create(email: 'bob@gmail.com', password: 'foo').valid?
  end

  test "should have unique email" do
    assert User.create(email: @email, password: @password).valid?
    assert_not User.create(email: @email, password: @password).valid?
  end

end
