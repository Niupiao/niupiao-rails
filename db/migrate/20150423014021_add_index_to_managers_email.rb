class AddIndexToManagersEmail < ActiveRecord::Migration
  def change
    add_index :managers, :email, unique: true
  end
end
