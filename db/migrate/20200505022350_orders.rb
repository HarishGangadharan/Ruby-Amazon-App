class Orders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :customer_id
      t.string :order_status

      t.timestamps
    end
  end
end
