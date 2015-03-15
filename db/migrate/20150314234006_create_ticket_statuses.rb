class CreateTicketStatuses < ActiveRecord::Migration
  def change
    create_table :ticket_statuses do |t|
      t.string :name
      t.integer :max_purchaseable
      t.references :event, index: true

      t.timestamps null: false
    end
    add_foreign_key :ticket_statuses, :events
  end
end
