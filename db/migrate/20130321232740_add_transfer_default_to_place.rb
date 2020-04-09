class AddTransferDefaultToPlace < ActiveRecord::Migration[4.2]
  def change
    add_column :places, :transfer_default, :boolean, default: false
  end
end
