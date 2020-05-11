class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.string :customer_id

      t.timestamps
    end
  end
end
