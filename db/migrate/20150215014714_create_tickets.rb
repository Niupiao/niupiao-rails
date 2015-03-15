class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.references :event, index: true
      t.references :user, index: true
      t.references :ticket_status, index: true
      t.integer :price

      t.timestamps null: false
    end
    add_foreign_key :tickets, :events
    add_foreign_key :tickets, :users
    add_foreign_key :tickets, :ticket_statuses
  end
end
