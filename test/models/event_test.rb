require 'test_helper'

class EventTest < ActiveSupport::TestCase
  test "should have name and date" do
    assert_not Event.create(organizer: 'Brent Heeringa').valid?
    assert Event.create(name: 'John Mayer', date: DateTime.now).valid?
  end
end
