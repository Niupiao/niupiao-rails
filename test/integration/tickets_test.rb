require 'test_helper'

class TicketsTest < ActionDispatch::IntegrationTest
  include IntegrationHelperTest

  def setup
    @event = Fabricate(:event)
    @user = User.create(username: 'kmc3', email: 'kmc3@williams.edu', password: 'foobar')
    login @user
  end

  test "should create ticket" do
    assert_difference('Ticket.count') do
      post "/events/#{@event.id}/tickets", ticket: {
        event_id: @event.id,
        user_id: @user.id,
        price: 100,
        status: Ticket::STATUS_VIP
      }
    end
  end

end
