require 'test_helper'
require 'integration/integration_helper_test'

class TicketsTest < ActionDispatch::IntegrationTest
  include IntegrationHelperTest

  def setup
    @event ||= Event.create!(
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
    @general ||= TicketStatus.create!(name: "General", max_purchasable: 3, price: 50)
    @vip ||= TicketStatus.create!(name: "VIP", max_purchasable: 2, price: 150)
    @event.ticket_statuses << @general
    @event.ticket_statuses << @vip
    @event.save!

    @user1 ||= User.create!(email: 'kmc3@williams.edu', password: 'foobar', name: 'Kevin Chen', first_name: 'Kevin', last_name: 'Chen')
    @user2 ||= User.create!(email: 'rhk1@williams.edu', password: 'foobar', name: 'Ryan Kwon',  first_name: 'Ryan',  last_name: 'Kwon')
  end

  def teardown
    @event.tickets.destroy_all
  end
  
  test "should inform user what they can buy" do
    
    # Create general tickets
    t1 = Ticket.create!(event: @event, ticket_status: @general)
    t2 = Ticket.create!(event: @event, ticket_status: @general)
    t3 = Ticket.create!(event: @event, ticket_status: @general)

    # Create VIP tickets
    t4 = Ticket.create!(event: @event, ticket_status: @vip)

    # ask what we can buy
    auth_post "/buywhat.json", @user1.api_key.access_token, {
                event_id: @event.id
              }

    gen_count = @event.tickets.with_status(@general.name).count
    assert_equal 3, gen_count
    
    vip_count = @event.tickets.with_status(@vip.name).count
    assert_equal 1, vip_count
    
    # we should be able to buy as much as we can
    assert_equal [gen_count, @general.max_purchasable].min, json['general']
    assert_equal [vip_count, @vip.max_purchasable].min, json['vip']

    # Buy a General and VIP ticket
    #t3.user = @user1
    #t4.user = @user1
    #t3.save!
    #t4.save!
    auth_post "/buy.json", @user1.api_key.access_token, { event_id: @event.id, tickets_purchased: { general: 1, vip: 1 } }

    # check again now
    auth_post "/buywhat.json", @user1.api_key.access_token, {
                event_id: @event.id
              }
    puts json
    assert_equal gen_count - 1, json['general']
    assert_equal vip_count - 1, json['vip']
    
  end
  
  test "should purchase multiple tickets by status" do
    t1 = Ticket.create!(event: @event, ticket_status: @general)
    t2 = Ticket.create!(event: @event, ticket_status: @general)
    t3 = Ticket.create!(event: @event, ticket_status: @general)

    t4 = Ticket.create!(event: @event, ticket_status: @vip)
    
    auth_post "/buy.json", @user1.api_key.access_token, {
      event_id: @event.id,
      tickets_purchased: {
        general: 2,
        vip: 2,
        fish: 3 #, general: 'f'   # TODO POSTing duplicate keys fails
      }
    }
    
    puts prettify(json)
    assert_equal 2, @user1.tickets.count
    assert_equal true, json['general']['success']
    assert_equal @event.id, json['general']['event_id'].to_i

    assert_equal false, json['fish']['success']
    assert_equal @event.id, json['fish']['event_id'].to_i
    assert_equal "No tickets with status: fish", json['fish']['message']

    t1 = t1.reload
    t2 = t2.reload
    t3 = t3.reload
    assert @user1.owns?(t1), "User does not own ticket..."
    assert @user1.owns?(t2), "User does not own ticket..."
    assert_equal @user1, t1.user, "User does not own ticket..."
    assert_equal @user1, t2.user, "User does not own ticket..."
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
