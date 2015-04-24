require 'test_helper'

class EventTest < ActiveSupport::TestCase

  def setup
    @name = 'John Mayer Concert'
    @date = DateTime.now

    @organizer = 'Brent Heeringa'
  end

  test "should have name and date" do
    assert_not Event.create(organizer: @organizer).valid?
    assert Event.create(name: @name, date: @date).valid?
  end

  test "should add tickets" do

    # make the event
    event = Event.create!(name: @name, date: @date)

    # make the event statuses
    vip = TicketStatus.create!(name: "VIP", max_purchasable: 2, price: 150)
    general = TicketStatus.create!(name: "General", max_purchasable: 3, price: 150)
    event.ticket_statuses << vip
    event.ticket_statuses << general
    event.save!

    # should have created the ticket statuses
    assert_equal 2, event.ticket_statuses.count

    # make the tickets
    Ticket.create!(event: event, ticket_status: vip)
    Ticket.create!(event: event, ticket_status: general)
    Ticket.create!(event: event, ticket_status: general)

    # should have some ticket statuses
    assert_equal 2, event.ticket_statuses.count

    # should have some tickets
    assert_equal 3, event.tickets.count

    # should have some number of tickets of a specific status
    assert_equal 1, event.tickets.with_status('vip').count
    assert_equal 2, event.tickets.with_status('general').count
  end
end
