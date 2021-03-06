class Provider < ApplicationRecord
  include PgSearch

  pg_search_scope :unicode_search,
    against: :name,
    ignoring: :accents,
    using: {
      tsearch: { any_word: true, prefix: true }
    }

  validates :name, :cuit, presence: true
  validates :cuit, uniqueness: true

  has_many :products

  def to_s
    [self.name, self.cuit].join(' - ')
  end

  alias_method :label, :to_s

  def as_json(options = nil)
    default_options = {
      only: [:id],
      methods: [:label]
    }

    super(default_options.merge(options || {}))
  end

  def increase_all_products!(percentage)
    add_percentage = percentage.to_f / 100 + 1

    Product.transaction do
      begin
        self.products.each do |product|
          product.increase_prices_with_percentage!(add_percentage)
        end
      rescue
        raise ActiveRecord::Rollback
      end
    end
  end
end
