class AddPasswordDigestToManagers < ActiveRecord::Migration
  def change
    add_column :managers, :password_digest, :string
  end
end
