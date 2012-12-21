class Customer < ActiveRecord::Base
  has_paper_trail
  has_magick_columns business_name: :string, cuit: :string

  KINDS = {
    iva_resp_insc: 'I',
    iva_resp_not_insc: 'R',
    not_resp: 'N',
    exempt_iva: 'E',
    resp_monot: 'M',
    final_consumer: 'F',
    not_categoriced: 'S',
    social_monot: 'T',
    small_event_contributor: 'C',
    social_small_event_contributor: 'V'
  }.with_indifferent_access.freeze

  BILL_KINDS = ['A', 'B', 'C', 'X']

  attr_accessible :name, :business_name, :iva_kind, :bill_kind, :address,
    :cuit, :phone

  validates :business_name, :iva_kind, :bill_kind, :cuit, presence: true
  validates :business_name, :cuit, uniqueness: true

  def to_s
    [self.business_name, self.cuit].join(' - ')
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
