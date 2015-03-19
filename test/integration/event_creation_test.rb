require 'test_helper'
require 'integration/integration_helper_test'

class EventCreationTest < ActionDispatch::IntegrationTest
  include IntegrationHelperTest

  def setup
    @user1 = User.create(email: 'kmc3@williams.edu', password: 'foobar', name: 'Kevin Chen', first_name: 'Kevin', last_name: 'Chen')
    login @user1
  end

  test "should create event" do
    
    now = DateTime.now
    # Create an event
    assert_difference('Event.count') do
      post '/events.json', event: {
             name: 'John Mayer',
             date: now,
             organizer: 'Brent Heeringa',
             location: 'Williamstown, MA',
             description: 'A concert',
#             image: '',
             link: 'some link',
             total_tickets: 14,
             ticket_statuses_attributes: [
               {
                 name: 'General',
                 max_purchasable: 3,
                 price: 50
               }
             ]
           }
    end

    puts prettify(json)

    assert_equal 1, Event.count
    event = Event.all.first
    assert_equal 'John Mayer', event.name
    assert_equal 14, event.total_tickets
    assert_equal 1, event.ticket_statuses.count
  end
    
  
end
