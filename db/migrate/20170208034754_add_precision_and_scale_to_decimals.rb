class AddPrecisionAndScaleToDecimals < ActiveRecord::Migration[5.0]
  def change
    change_column :product_lines, :quantity, :decimal, precision: 10, scale: 3
    change_column :product_lines, :price, :decimal, precision: 15, scale: 2

    change_column :sales, :total_price, :decimal, precision: 15, scale: 2
  end
end
