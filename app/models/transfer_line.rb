class TransferLine < ApplicationRecord

  attr_accessor :auto_product_name
  #attr_accessible :product_id, :transfer_product_id, :quantity,
  #  :auto_product_name, :price

  validates :product_id, :quantity, presence: true

  before_save :discount_stock

  belongs_to :product
  belongs_to :transfer_product

  def initialize(attributes = {})
    super(attributes)

    self.price = self.product.try(:iva_cost) || 0
  end

  def discount_stock
    self.product.put_to_stock -self.quantity
  end

  def line_price
    (self.price || 0) * (self.quantity || 0)
  end
end
