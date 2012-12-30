class Sale < ActiveRecord::Base
  has_paper_trail

  attr_accessor :seller_code, :auto_customer_name
  attr_accessible :customer_id, :seller_id, :sale_kind, :total_price,
    :seller_code, :auto_customer_name

  validates :seller_id, :total_price, presence: true
  validates :sale_kind, length: { maximum: 1 }
  validates :total_price, numericality: { allow_nil: true, allow_blank: true }

  belongs_to :seller
  belongs_to :customer
  has_many :product_lines, inverse_of: :sale, dependent: :destroy
end
