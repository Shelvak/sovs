class AddPlaceIdToSale < ActiveRecord::Migration
  def up
    add_column :sales, :place_id, :integer
  end

  def down
    remove_column :sales, :place_id
  end
end
