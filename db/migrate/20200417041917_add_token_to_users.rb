class AddTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pwdresettoken, :string
  end
end
