class ProductLine < ActiveRecord::Base
  has_paper_trail

  attr_accessor :auto_product_name
  attr_accessible :product_id, :quantity, :price, :sale_id, :auto_product_name

  validates :product_id, :quantity, :price, :sale_id, presence: true

  belongs_to :product
  belongs_to :sale
end
