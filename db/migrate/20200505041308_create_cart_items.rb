class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.integer :quantity
      t.references :cart, index: true
      t.references :product, index: true

      t.timestamps
    end
  end
end
