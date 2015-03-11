class CreateFacebookIdentities < ActiveRecord::Migration
  def change
    create_table :facebook_identities do |t|
      t.string :birthday
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :name
      t.string :username
      t.string :location
      t.string :link
      t.string :facebook_id
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
