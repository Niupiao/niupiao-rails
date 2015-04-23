class AddManagerIdToEvent < ActiveRecord::Migration
  def change
    add_reference :events, :manager, index:true
  end
end
