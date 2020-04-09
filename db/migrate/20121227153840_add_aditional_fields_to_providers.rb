class AddAditionalFieldsToProviders < ActiveRecord::Migration[4.2]
  def up
    add_column :providers, :other_phone, :string
    add_column :providers, :locality, :string
    add_column :providers, :city, :string
    add_column :providers, :province, :string
    add_column :providers, :fax, :string
    add_column :providers, :postal_code, :integer
  end

  def down
    remove_column :providers, :other_phone, :string
    remove_column :providers, :locality, :string
    remove_column :providers, :city, :string
    remove_column :providers, :province, :string
    remove_column :providers, :fax, :string
    remove_column :providers, :postal_code, :integer
  end
end
