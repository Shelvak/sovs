class ProductLine < ActiveRecord::Base
  has_paper_trail

  attr_accessor :auto_product_name
  attr_accessible :product_id, :quantity, :price, :sale_id, :auto_product_name

  validates :product_id, :quantity, :price, presence: true
  validates :quantity, :price, numericality: { allow_nil: true, allow_blank: true,
    greater_than: 0 }

  belongs_to :product
  belongs_to :sale
end
