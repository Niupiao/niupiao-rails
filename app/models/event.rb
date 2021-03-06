class Event < ActiveRecord::Base  

  has_many :tickets, dependent: :destroy,
           after_add: :increment_total_tickets,
           after_remove: :decrement_total_tickets
  has_many :ticket_statuses

  accepts_nested_attributes_for :ticket_statuses  

  validates :name, :date, presence: true

  def as_json(options={})
    super(include: :ticket_statuses).merge(number_of_ticket_statuses: ticket_statuses.length)
  end
  
  private
  
  def increment_total_tickets(ticket)
    self.total_tickets += 1
  end

  def decrement_total_tickets(ticket)
    self.total_tickets -= 1
  end
  
end
