require 'test_helper'

class TicketsTest < ActionDispatch::IntegrationTest
  include IntegrationHelperTest

  def setup
    @event = Event.create!(
                           name: 'TestEvent',
                           organizer: 'TestOrganizer',
                           location: 'Williamstown, MA',
                           description: 'TestDescription',
                           image_path: 'TestImagePath',
                           link: 'TestLink',
                           total_tickets: 0,
                           tickets_sold: 0
                           )
    @general = TicketStatus.create!(name: "General", max_purchasable: 3)
    @vip = TicketStatus.create!(name: "VIP", max_purchasable: 2)
    @event.ticket_statuses << @general
    @event.ticket_statuses << @vip
    @event.save!

    @user = User.create(username: 'kmc3', email: 'kmc3@williams.edu', password: 'foobar', name: 'Kevin Chen', first_name: 'Kevin', last_name: 'Chen')
    login @user
  end

  test "should create ticket" do
    assert_difference('Ticket.count') do
      post "/events/#{@event.id}/tickets", ticket: {
        event_id: @event.id,
        user_id: @user.id,
        price: 100,
        ticket_status_id: @general.id
      }
    end
  end

end
