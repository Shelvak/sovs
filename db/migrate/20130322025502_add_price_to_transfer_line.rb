class AddPriceToTransferLine < ActiveRecord::Migration
  def change
    add_column :transfer_lines, :price, :decimal, precision: 15, scale: 2
  end
end
