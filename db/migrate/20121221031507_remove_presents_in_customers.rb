class RemovePresentsInCustomers < ActiveRecord::Migration
  def change
    change_column :customers, :business_name, :string, null: true
    change_column :customers, :cuit, :string, null: true
  end
end
