class CreateSellers < ActiveRecord::Migration[4.2]
  def change
    create_table :sellers do |t|
      t.integer :code, null: false
      t.string :name, null: false
      t.string :address
      t.string :phone

      t.timestamps
    end

    add_index :sellers, :code, unique: true
    add_index :sellers, :name
  end
end
