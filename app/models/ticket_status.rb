class TicketStatus < ActiveRecord::Base
  belongs_to :event
  has_many :tickets

  before_create :downcase_status

  validates :price, presence: true
  validates :name, presence: true
  validates :max_purchasable, presence: true

  private
  def downcase_status
    self.name.downcase!
  end  
  
end
