class ApiKey < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.belongs_to :user
      t.string :access_token
      t.integer :expires_at
      
      t.timestamps null: false
    end
    
  end
end
