class AddTotalPriceToTransferProduct < ActiveRecord::Migration[4.2]
  def change
    add_column :transfer_products, :total_price, :decimal, precision: 15, scale: 2
  end
end
