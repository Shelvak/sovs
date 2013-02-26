class AddDefaultPriceTypeToCustomer < ActiveRecord::Migration
  def up
    add_column :customers, :default_price_type, :string
  end

  def down
    remove_column :customers, :default_price_type
  end
end
