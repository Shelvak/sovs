class CodeToStringInProduct < ActiveRecord::Migration
  def up
    remove_index :products, :code
    change_column :products, :code, :string, null: false
    add_index :products, :code, unique: true
  end

  def down
    remove_index :products, :code
    change_column :products, :code, :integer, null: false
    add_index :products, :code, unique: true
  end
end
