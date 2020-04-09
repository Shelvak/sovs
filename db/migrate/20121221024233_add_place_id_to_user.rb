class AddPlaceIdToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :place_id, :integer
  end
end
