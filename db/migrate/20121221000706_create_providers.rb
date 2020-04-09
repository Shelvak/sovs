class CreateProviders < ActiveRecord::Migration[4.2]
  def change
    create_table :providers do |t|
      t.string :name, null: false
      t.string :contact
      t.string :address
      t.string :cuit, null: false
      t.string :phone

      t.timestamps
    end

    add_index :providers, :cuit, unique: true
    add_index :providers, :name
  end
end
