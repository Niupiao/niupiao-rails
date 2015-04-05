require 'test_helper'

class TicketTest < ActiveSupport::TestCase

  def setup
    @user1 = User.create!(email: 'kmc3@williams.edu', password: 'foobar', name: 'Kevin Chen', first_name: 'Kevin', last_name: 'Chen')
  end

  test "should have event and ticket status" do
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

    t1 = Ticket.create!(event: @event, ticket_status: @vip)
    t2 = Ticket.create!(event: @event, ticket_status: @vip)

    t3 = Ticket.create!(event: @event, ticket_status: @general)
    t4 = Ticket.create!(event: @event, ticket_status: @general)

    assert_equal 4, @event.tickets.unowned.count
    t2.user = @user1
    t2.save!
    assert_equal 3, @event.tickets.unowned.count

    assert_equal 2, @event.tickets.with_status('General').count
    assert_equal 2, @event.tickets.with_status('VIP').count
    

  end
end
