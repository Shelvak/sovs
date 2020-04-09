class CreateProductLines < ActiveRecord::Migration[4.2]
  def change
    create_table :product_lines do |t|
      t.integer :product_id, null: false
      t.decimal :quantity, null: false
      t.decimal :price, precision: 15, scale: 2, null: false
      t.integer :sale_id, null: false

      t.timestamps
    end
    add_index :product_lines, :product_id
    add_index :product_lines, :sale_id
  end
end
