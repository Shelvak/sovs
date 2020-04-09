class ProductLine < ApplicationRecord

  scope :at_day, ->(day) { where(
    [
      "#{ProductLine.table_name}.created_at >= :start",
      "#{ProductLine.table_name}.created_at <= :finish"
    ].join(' AND '), start: day.beginning_of_day, finish: day.end_of_day
  ) }

  attr_accessor :auto_product_name, :unit_price_tmp, :retail_price_tmp,
    :special_price_tmp
  #attr_accessible :product_id, :quantity, :price, :sale_id, :auto_product_name,
  #  :unit_price, :price_type, :unit_price_tmp, :retail_price_tmp,
  #  :special_price_tmp

  validates :product_id, :quantity, :unit_price, presence: true
  validates :quantity, numericality: {
    allow_nil: true, allow_blank: true
  }
  validates :unit_price, numericality: {
    allow_nil: true, allow_blank: true, greater_than: 0
  }

  belongs_to :product, optional: true
  belongs_to :sale, optional: true

  before_validation :assign_prices_snapshot
  before_create :assign_prices_snapshot

  def assign_prices_snapshot
    [
      :cost, :gain, :iva_cost, :retail_price, :special_gain, :special_price,
      :unit_gain, :unit_price
    ].each do |attr|
      self[attr] = self.product[attr]
    end
    self.price = self.send(self.price_type)
  end

  def price_type_or_default
    self.price_type || 'retail_price'
  end

  def final_price
    (self.try(self.price_type_or_default) || 0.0) * (self.quantity || 1)
  end

  def price_without_taxes
    tax = (self.iva_cost / self.cost).round(2)
    (self.final_price / tax)
  end
end
