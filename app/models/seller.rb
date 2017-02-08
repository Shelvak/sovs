class Seller < ActiveRecord::Base
  has_paper_trail

  # attr_accessible :code, :name, :address, :phone

  validates :code, :name, presence: true
  validates :code, uniqueness: true

  has_many :sales

  def to_s
    ["[#{self.code}]", self.name].join(' ')
  end

  def count_and_sold_of_sales_on_day(day)
    sales = self.sales.in_day(day)
    [sales.count, sales.sum(&:total_price).round(3)]
  end
end
