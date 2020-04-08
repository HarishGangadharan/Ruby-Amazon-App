class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.text :desccriptioin

      t.timestamps
    end
  end
end
