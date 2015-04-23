require 'test_helper'

class ManagerTest < ActiveSupport::TestCase
  
  def setup
    @manager = Manager.new(organization: "NiuPiao", email: "ryan@niupiao.io",
                           password: "niupiao", password_confirmation: "niupiao")
  end
  
  test "should be valid" do
    assert @manager.valid?
  end
  
  test "organization should be present" do
    @manager.organization = "   "
    assert_not @manager.valid?
  end
  
  test "email should be present" do
    @manager.email = "    "
    assert_not @manager.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @manager.email = valid_address
      assert @manager.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @manager.email = invalid_address
      assert_not @manager.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_manager = @manager.dup
    @manager.save
    assert_not duplicate_manager.valid?
  end
  
  #Forces password length to be at least 6 characters
  test "password should have a minimum length" do
    @manager.password = @manager.password_confirmation = "a" * 5
    assert_not @manager.valid?
  end
  
end
