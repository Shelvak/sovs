class AddPreferenceToProduct < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :preference, :boolean, default: false
  end
end
