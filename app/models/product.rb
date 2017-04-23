class Product < ActiveRecord::Base
  has_paper_trail

  scope :with_code, ->(code) { where(code: code) }
  scope :with_preference, ->() { where(preference: true).order(:code) }
  scope :with_low_stock, ->() { where(
    "#{Product.table_name}.total_stock <= #{Product.table_name}.min_stock"
  ) }
  scope :with_recent_sales, -> () { includes(:product_lines).where(
    product_lines: { created_at: 15.days.ago..Date.today }
  ).uniq }

  before_save :recalc_packs_count

  attr_accessor :auto_provider_name

  #attr_accessible :code, :description, :retail_unit, :purchase_unit,
  #  :unity_relation, :total_stock, :min_stock, :packs, :preference,
  #  :cost, :iva_cost, :gain, :retail_price, :unit_price, :special_price,
  #  :provider_id, :auto_provider_name, :unit_gain, :special_gain

  validates :code, :description, presence: true
  validates :code, uniqueness: true
  validates :retail_unit, :purchase_unit, length: { maximum: 2 }
  validates :unity_relation, :total_stock, :min_stock, :cost, :packs,
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

  def self.filtered_list(query)
    all
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
    self.total_stock += quantity
    recalc_packs_count # Product method
    self.save!
  end

  def recalc_packs_count
    self.packs = (self.total_stock.to_f / self.unity_relation.to_f).round(2)
  end
end
