class Ticket < ActiveRecord::Base
  scope :owned_by, ->(user) { where(user_id: user.id) }

  belongs_to :event
  belongs_to :user

  STATUS_VIP = "vip"
  STATUS_GENERAL = "general"

  def vip_status?
    self.status == STATUS_VIP
  end

  def general_status?
    self.status == STATUS_GENERAL
  end
  
end
