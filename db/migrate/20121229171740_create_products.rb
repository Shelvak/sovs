class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :code, null: false
      t.string :description, null: false
      t.string :retail_unit, limit: 2
      t.string :purchase_unit, limit: 2
      t.decimal :unity_relation, precision: 15, scale: 2 
      t.decimal :total_stock, precision: 15, scale: 2
      t.decimal :min_stock, precision: 15, scale:2 
      t.integer :packs
      t.decimal :pack_content, precision: 15, scale:2 
      t.decimal :cost, precision: 15, scale:2 
      t.decimal :iva_cost, precision: 15, scale:2 
      t.decimal :gain, precision: 4, scale:2 
      t.decimal :retail_price, precision: 15, scale:2 
      t.decimal :unit_price, precision: 15, scale:2 
      t.decimal :special_price, precision: 15, scale:2 
      t.integer :provider_id

      t.timestamps
    end

    add_index :products, :code, unique: true
    add_index :products, :description
    add_index :products, :provider_id
  end
end
