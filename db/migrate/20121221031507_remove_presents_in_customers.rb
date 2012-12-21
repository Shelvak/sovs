class RemovePresentsInCustomers < ActiveRecord::Migration
  def change
    execute 'ALTER TABLE customers ALTER COLUMN business_name DROP NOT NULL;'
    execute 'ALTER TABLE customers ALTER COLUMN cuit DROP NOT NULL;'
  end
end
