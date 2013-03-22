class AddTransferDefaultToPlace < ActiveRecord::Migration
  def change
    add_column :places, :transfer_default, :boolean, default: false
  end
end
