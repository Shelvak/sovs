class AddPricesToProductLine < ActiveRecord::Migration[5.0]
  def change
    [
      :cost, :gain, :iva_cost, :retail_price, :special_gain, :special_price, :unit_gain
    ].each do |attr|
      add_column :product_lines, attr, :decimal, precision: 15, scale: 2, null: false
    end
  end
end
