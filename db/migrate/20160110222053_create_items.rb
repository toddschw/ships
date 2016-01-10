class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :category
      t.integer :length
      t.integer :width
      t.integer :height
      t.integer :weight

      t.timestamps null: false
    end
  end
end
