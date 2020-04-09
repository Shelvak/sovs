class CreateSales < ActiveRecord::Migration[4.2]
  def change
    create_table :sales do |t|
      t.integer :customer_id
      t.integer :seller_id, null: false
      t.string :sale_kind, limit: 1
      t.decimal :total_price, null: false

      t.timestamps
    end

    add_index :sales, :customer_id
    add_index :sales, :seller_id
  end
end
