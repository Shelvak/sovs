class AddUnitPriceToProductLine < ActiveRecord::Migration
  def up
    add_column :product_lines, :unit_price, :decimal, precision: 15, scale: 2, null: false
  end

  def down
    remove_column :product_lines, :unit_price
  end
end
