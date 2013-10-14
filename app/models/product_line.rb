class ProductLine < ActiveRecord::Base
  has_paper_trail

  scope :at_day, ->(day) { where(
    [
      "#{ProductLine.table_name}.created_at >= :start",
      "#{ProductLine.table_name}.created_at <= :finish"
    ].join(' AND '), start: day.beginning_of_day, finish: day.end_of_day
  ) }

  attr_accessor :auto_product_name, :unit_price_tmp, :retail_price_tmp,
    :special_price_tmp
  attr_accessible :product_id, :quantity, :price, :sale_id, :auto_product_name,
    :unit_price, :price_type, :unit_price_tmp, :retail_price_tmp,
    :special_price_tmp

  validates :product_id, :quantity, :price, :unit_price, presence: true
  validates :quantity, :price, numericality: { 
    allow_nil: true, allow_blank: true
  }
  validates :unit_price, numericality: {
    allow_nil: true, allow_blank: true, greater_than: 0
  }

  belongs_to :product
  belongs_to :sale
end
