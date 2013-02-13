class ModifyPacksProduct < ActiveRecord::Migration
  def up
    remove_column :products, :pack_content
    change_column :products, :packs, :decimal, precision: 15, scale: 2
  end

  def down
    add_column :products, :pack_content, :decimal, precision: 15, scale: 2
    change_column :products, :packs, :integer
  end
end
