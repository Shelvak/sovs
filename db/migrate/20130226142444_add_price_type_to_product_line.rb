class AddPriceTypeToProductLine < ActiveRecord::Migration
  def up
    add_column :product_lines, :price_type, :string
  end

  def down
    remove_column :product_lines, :price_type
  end
end
