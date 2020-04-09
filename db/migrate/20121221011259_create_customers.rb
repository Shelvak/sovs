class CreateCustomers < ActiveRecord::Migration[4.2]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :business_name, null: false
      t.string :iva_kind, null: false, limit: 1
      t.string :bill_kind, null: false, limit: 1
      t.string :address
      t.string :cuit, null: false
      t.string :phone

      t.timestamps
    end

    add_index :customers, :business_name, unique: true
    add_index :customers, :cuit, unique: true
  end
end
