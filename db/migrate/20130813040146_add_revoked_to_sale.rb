class AddRevokedToSale < ActiveRecord::Migration
  def change
    add_column :sales, :revoked, :boolean, default: false
  end
end
