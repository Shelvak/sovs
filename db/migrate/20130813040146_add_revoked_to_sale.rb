class AddRevokedToSale < ActiveRecord::Migration[4.2]
  def change
    add_column :sales, :revoked, :boolean, default: false
  end
end
