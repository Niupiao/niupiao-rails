require 'test_helper'

class TicketTest < ActiveSupport::TestCase

  test "should have event and ticket status" do
    @event = Event.create(name: 'John Mayer Concert', date: DateTime.now)
    @event.ticket_statuses << TicketStatus.create(price: 50, name: 'General', max_purchasable: 3)
    assert Ticket.create(event: @event, ticket_status: @event.ticket_statuses.first).valid?
  end
end
