class CreateTransferProducts < ActiveRecord::Migration[4.2]
  def change
    create_table :transfer_products do |t|
      t.integer :place_id

      t.timestamps
    end
  end
end
