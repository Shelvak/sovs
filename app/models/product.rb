class Product < ActiveRecord::Base
  has_paper_trail
  has_magick_columns code: :integer, description: :string

  scope :with_code, ->(code) { where("code = :code", code: code.to_i) }

  attr_accessor :auto_provider_name

  attr_accessible :code, :description, :retail_unit, :purchase_unit,
    :unity_relation, :total_stock, :min_stock, :packs, 
    :cost, :iva_cost, :gain, :retail_price, :unit_price, :special_price,
    :provider_id, :auto_provider_name, :unit_gain, :special_gain

  validates :code, :description, presence: true
  validates :code, uniqueness: true
  validates :retail_unit, :purchase_unit, length: { maximum: 2 }
  validates :unity_relation, :total_stock, :min_stock, :cost, :packs,
    :iva_cost, :retail_price, :unit_price, :special_price, :gain, :unit_gain,
    :special_gain, numericality: { allow_nil: true, allow_blank: true }

  belongs_to :provider
  has_many :product_lines

  def to_s
    "[#{self.code}] #{self.description}"
  end

  alias_method :label, :to_s

  def as_json(options = nil)
    default_options = {
      only: [:id],
      methods: [:label, :retail_price]
    }

    super(default_options.merge(options || {}))
  end

  def self.filtered_list(query)
    query.present? ? magick_search(query) : scoped
  end

  def increase_prices_with_percentage!(percentage)
    self.cost *= percentage
    self.iva_cost *= percentage
    self.retail_price *= percentage
    self.unit_price *= percentage
    self.special_price *= percentage
    self.save!
  end

  def discount_stock(quantity)
    self.total_stock -= quantity
    self.packs = total_stock.to_i / self.packs if self.packs.to_f > 0.00
    self.save!
  end
end
