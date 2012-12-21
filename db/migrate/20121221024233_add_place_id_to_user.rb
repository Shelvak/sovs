class AddPlaceIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :place_id, :integer
  end
end
