class AddGainsToProduct < ActiveRecord::Migration
  def up
    add_column :products, :unit_gain, :decimal, precision: 15, scale: 2
    add_column :products, :special_gain, :decimal, precision: 15, scale: 2
  end

  def down
    remove_column :products, :unit_gain
    remove_column :products, :special_gain
  end
end
