class AddAddressToUser < ActiveRecord::Migration
  def change
    add_column :users, :addressline, :string
    add_column :users, :street, :string
    add_column :users, :city, :string
    add_column :users, :pincode, :integer
  end
end
