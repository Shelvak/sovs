class RemovePresentsInCustomers < ActiveRecord::Migration[4.2]
  def change
    change_column :customers, :business_name, :string, null: true
    change_column :customers, :cuit, :string, null: true
  end
end
