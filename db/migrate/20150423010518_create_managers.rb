class CreateManagers < ActiveRecord::Migration
  def change
    create_table :managers do |t|
      t.string :email
      t.string :organization

      t.timestamps null: false
    end
  end
end
