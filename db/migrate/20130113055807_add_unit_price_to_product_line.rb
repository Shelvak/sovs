class AddUnitPriceToProductLine < ActiveRecord::Migration[4.2]
  def up
    add_column :product_lines, :unit_price, :decimal, precision: 15, scale: 2, default: 0.0, null: false
  end

  def down
    remove_column :product_lines, :unit_price
  end
end
