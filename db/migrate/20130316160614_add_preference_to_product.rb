class AddPreferenceToProduct < ActiveRecord::Migration
  def change
    add_column :products, :preference, :boolean, default: false
  end
end
