require 'test_helper'

class EventsEditTest < ActionDispatch::IntegrationTest
  include IntegrationHelperTest
  
  def setup
    @user1 = User.create(email: 'kmc3@williams.edu', password: 'foobar', name: 'Kevin Chen', first_name: 'Kevin', last_name: 'Chen')
    login @user1
    @event = { name: 'John Mayer', date: DateTime.now }
  end
end
