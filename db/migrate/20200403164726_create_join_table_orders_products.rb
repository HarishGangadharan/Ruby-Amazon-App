class CreateJoinTableOrdersProducts < ActiveRecord::Migration
  def change
    create_join_table :Orders, :Products do |t|
      # t.index [:order_id, :product_id]
      # t.index [:product_id, :order_id]
      t.integer :price
      t.integer :quantity
    end
  end
end
