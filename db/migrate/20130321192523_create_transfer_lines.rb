class CreateTransferLines < ActiveRecord::Migration[4.2]
  def change
    create_table :transfer_lines do |t|
      t.integer :product_id, null: false
      t.decimal :quantity, null: false, precision: 10, scale: 3
      t.integer :transfer_product_id, null: false

      t.timestamps
    end

    add_index :transfer_lines, :product_id
    add_index :transfer_lines, :transfer_product_id
  end
end
