class AddTicketStatusToTicket < ActiveRecord::Migration
  def change
    add_reference :tickets, :ticket_status, index: true
    add_foreign_key :tickets, :ticket_statuses
  end
end
