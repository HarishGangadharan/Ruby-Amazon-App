class AddColumnsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :created_by, :string
    add_column :products, :modified_by, :string
  end
end
