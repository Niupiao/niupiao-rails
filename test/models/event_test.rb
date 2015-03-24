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
end
