class CreateProductsOrders < ActiveRecord::Migration
  def change
    create_table :products_orders do |t|
      t.references :product
      t.references :order
      t.integer :price
      t.integer :quantity
    end
  end
end
