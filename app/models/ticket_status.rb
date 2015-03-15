class TicketStatus < ActiveRecord::Base
  belongs_to :event
  has_many :tickets

  validates :price, presence: true
  validates :name, presence: true
  validates :max_purchasable, presence: true
  
end
