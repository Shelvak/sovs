class Product < ActiveRecord::Base
  has_paper_trail
  has_magick_columns code: :integer, description: :string

  attr_accessor :auto_provider_name

  attr_accessible :code, :description, :retail_unit, :purchase_unit,
    :unity_relation, :total_stock, :min_stock, :packs, :pack_content, 
    :cost, :iva_cost, :gain, :retail_price, :unit_price, :special_price,
    :provider_id, :auto_provider_name

  validates :code, :description, presence: true
  validates :code, uniqueness: true
  validates :retail_unit, :purchase_unit, length: { maximum: 2 }
  validates :packs, numericality: { 
    allow_nil: true, allow_blank: true, only_integer: true
  }
  validates :unity_relation, :total_stock, :min_stock, :pack_content, :cost, 
    :iva_cost, :retail_price, :unit_price, :special_price, :gain, 
    numericality: { allow_nil: true, allow_blank: true }

  belongs_to :provider
  has_many :product_lines

  def to_s
    [self.code, self.description].join(' - ')
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
end
