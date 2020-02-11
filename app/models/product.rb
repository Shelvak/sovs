class Product < ApplicationRecord
  include PgSearch

  pg_search_scope :unicode_search,
    against: { code: 'A', description: 'B' },
    ignoring: :accents,
    using: {
      tsearch: { any_word: true, prefix: true }
    }

  scope :with_code, ->(code) { where(code: code) }
  scope :with_preference, ->() { where(preference: true).order(:code) }
  scope :with_low_stock, ->() { where(
    "#{Product.table_name}.total_stock <= #{Product.table_name}.min_stock"
  ) }
  scope :with_recent_sales, -> () { includes(:product_lines).where(
    product_lines: { created_at: 15.days.ago..Date.today }
  ).uniq }

  after_initialize :assign_defaults

  def assign_defaults
    self.total_stock    = 0 if total_stock.blank?
  end

  attr_accessor :auto_provider_name

  validates :code, :description, presence: true
  validates :code, uniqueness: true
  validates :retail_unit, :purchase_unit, length: { maximum: 2 }
  validates :cost, presence: true
  validates :total_stock, :min_stock, :cost,
    :iva_cost, :retail_price, :unit_price, :special_price, :gain, :unit_gain,
    :special_gain, numericality: { allow_nil: true, allow_blank: true }

  belongs_to :provider
  has_many :product_lines
  has_many :transfer_lines

  def to_s
    "[#{self.code}] #{self.description}"
  end

  alias_method :label, :to_s

  def as_json(options = nil)
    default_options = {
      only: [:id],
      methods: [
        :label, :retail_price, :unit_price, :special_price, :retail_unit,
        :iva_cost
      ]
    }

    super(default_options.merge(options || {}))
  end

  def increase_prices_with_percentage!(percentage)
    self.cost *= percentage
    self.iva_cost *= percentage
    self.retail_price *= percentage
    self.unit_price *= percentage
    self.special_price *= percentage
    self.save!
  end

  def put_to_stock(quantity)
    self.total_stock ||= 0
    self.total_stock += quantity
    self.save!
  end
end
