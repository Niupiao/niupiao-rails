class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :organizer
      t.date :date
      t.string :location
      t.string :description
      t.string :image_path
      t.string :link
      t.integer :total_tickets
      t.integer :tickets_sold

      t.timestamps null: false
    end
  end
end
