class CreatePlaces < ActiveRecord::Migration[4.2]
  def change
    create_table :places do |t|
      t.string :description, null: false

      t.timestamps
    end

    add_index :places, :description, unique: true
  end
end
