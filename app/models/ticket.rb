class Ticket < ActiveRecord::Base
  scope :owned_by, ->(user) { where(user_id: user.id) }
  scope :unowned, -> { where(user_id: nil) }
  scope :with_status, ->(status) { where(status: status) }

  belongs_to :event
  belongs_to :ticket_status  
  belongs_to :user

  before_create :downcase_status

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


  private
  def downcase_status
    self.status.downcase!
  end  
  
end
