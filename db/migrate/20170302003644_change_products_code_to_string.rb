class ChangeProductsCodeToString < ActiveRecord::Migration[5.0]
  def change
    change_column :products, :code, :string
  end
end
