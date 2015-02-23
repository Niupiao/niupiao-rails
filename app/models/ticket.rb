class Ticket < ActiveRecord::Base
  scope :owned_by, ->(user) { where(user_id: user.id) }

  belongs_to :event
  belongs_to :user
end
