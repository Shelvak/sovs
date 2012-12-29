class Provider < ActiveRecord::Base
  has_paper_trail
  has_magick_columns name: :string, cuit: :string

  attr_accessible :name, :contact, :address, :cuit, :phone, :other_phone,
    :locality, :city, :province, :fax, :postal_code

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

  def self.filtered_list(query)
    query.present? ? magick_search(query) : scoped
  end
end
