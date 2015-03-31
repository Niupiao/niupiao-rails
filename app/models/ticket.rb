class Ticket < ActiveRecord::Base
  scope :owned_by, ->(user) { where(user_id: user.id) }

  belongs_to :event
  belongs_to :ticket_status  
  belongs_to :user

  validates :event, presence: true
  validates :ticket_status, presence: true

  def initialize(attributes = {})
    super
    self.status = self.ticket_status.name
  end

  def as_json(options={})
    super(include: :ticket_status)
  end

  def owned_by?(owner)
    self.user == owner
  end
  
end
