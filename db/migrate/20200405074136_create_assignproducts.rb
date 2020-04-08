class CreateAssignproducts < ActiveRecord::Migration
  def change
    create_table :assignproducts do |t|

      t.timestamps
    end
  end
end
