require 'test_helper'

class EventsTest < ActionDispatch::IntegrationTest
  include IntegrationHelperTest

  def setup
    @user1 = User.create(email: 'kmc3@williams.edu', password: 'foobar', name: 'Kevin Chen', first_name: 'Kevin', last_name: 'Chen')
    login @user1
  end

  test "should create event" do
    # Create an event
    assert_difference('Event.count') do
      post '/events.json', event: {
             name: '',
             date: '',
             organizer: '',
             location: '',
             description: '',
             image: '',
             link: '',
             total_tickets: '',
             ticket_statuses: [
               {
                 name: 'General',
                 max_purchasable: 3,
                 price: 50
               }
             ]
           }
    end
  end
    
  
end
