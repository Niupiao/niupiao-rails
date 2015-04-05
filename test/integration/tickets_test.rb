require 'test_helper'
require 'integration/integration_helper_test'

class TicketsTest < ActionDispatch::IntegrationTest
  include IntegrationHelperTest

  def setup
    @event = Event.create!(
                           name: 'TestEvent',
                           date: DateTime.now,
                           organizer: 'TestOrganizer',
                           location: 'Williamstown, MA',
                           description: 'TestDescription',
                           image_path: 'TestImagePath',
                           link: 'TestLink',
                           total_tickets: 0,
                           tickets_sold: 0
                           )
    @general = TicketStatus.create!(name: "General", max_purchasable: 3, price: 50)
    @vip = TicketStatus.create!(name: "VIP", max_purchasable: 2, price: 150)
    @event.ticket_statuses << @general
    @event.ticket_statuses << @vip
    @event.save!

    @user1 = User.create!(email: 'kmc3@williams.edu', password: 'foobar', name: 'Kevin Chen', first_name: 'Kevin', last_name: 'Chen')
    @user2 = User.create!(email: 'rhk1@williams.edu', password: 'foobar', name: 'Ryan Kwon',  first_name: 'Ryan',  last_name: 'Kwon')
  end

  test "should purchase multiple tickets by status" do
    t1 = Ticket.create!(event: @event, ticket_status: @general)
    t2 = Ticket.create!(event: @event, ticket_status: @general)
    t3 = Ticket.create!(event: @event, ticket_status: @general)

    auth_post "/buy.json", @user1.api_key.access_token, {
      event_id: @event.id,
      tickets_purchased: {
        general: 2, 
        fish: 3,
        general: 'f'
      }
    }
    
    puts prettify(json)
    assert_equal true, json[0]['success']
    assert_equal @event.id, json[0]['event_id']

    assert_equal false, json[1]['success']
    assert_equal @event.id, json[1]['event_id']
    assert_equal "No tickets with status: fish", json[1]['message']
  end

  test "should purchase multiple tickets by id" do
    t1 = Ticket.create!(event: @event, ticket_status: @general)
    t2 = Ticket.create!(event: @event, ticket_status: @general)
    t3 = Ticket.create!(event: @event, ticket_status: @general)

    auth_post "/buy.json", @user1.api_key.access_token, {
      event_id: @event.id,
      ticket_ids: [t1.id, t2.id, t3.id, 4]
    }

    t1 = t1.reload
    t2 = t2.reload
    t3 = t3.reload
    assert @user1.owns?(t1), "User does not own ticket..."
    assert @user1.owns?(t2), "User does not own ticket..."
    assert @user1.owns?(t3), "User does not own ticket..."
    assert_equal @user1, t1.reload.user, "User does not own ticket..."
    assert_equal @user1, t2.reload.user, "User does not own ticket..."
    assert_equal @user1, t2.reload.user, "User does not own ticket..."
  end

  test "should buy ticket" do

    # Create a ticket that NO ONE owns
    ticket = Ticket.create!(event: @event, ticket_status: @general)

    # Try to Buy the ticket without authorization
    post "/events/#{@event.id}/tickets/#{ticket.id}/buy.json"
    assert :invalid_token.to_s, json['error']

    # Buy with authorization
    auth_post "/events/#{@event.id}/tickets/#{ticket.id}/buy.json", @user1.api_key.access_token
    assert_not_nil json['ticket'], "JSON response should have a value for 'ticket' key..."
    assert_not_nil json['user'], "JSON response should have a value for 'user' key..."
    assert_not_nil json['event'], "JSON response should have a value for 'event' key..."
    assert_equal @user1.id, json['ticket']['user_id']
    assert_equal @user1, ticket.reload.user, "User does not own ticket..."

    
  end
  
  test "MyTickets should only show tickets you own" do

    # Create a ticket that we User1 owns
    assert_difference('Ticket.count') do
      post "/events/#{@event.id}/tickets", ticket: {
        event_id: @event.id,
        user_id: @user1.id,
        ticket_status_id: @general.id
      }
    end

    # Create a ticket that NO ONE owns
    assert_difference('Ticket.count') do
      post "/events/#{@event.id}/tickets", ticket: {
        event_id: @event.id,
        ticket_status_id: @general.id
      }
    end

    # Get my tickets
    token = @user1.api_key.access_token
    auth_get '/me/tickets.json', token
    assert_equal @user1.my_tickets, json

    auth_get '/me/tickets.json', 'badToken'
    assert_equal :invalid_token.to_s, json['error']
    
  end

end
