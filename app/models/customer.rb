class Customer < ActiveRecord::Base
  has_paper_trail
  has_magick_columns name: :string, business_name: :string, cuit: :string

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

  validate :validate_customer_kind
  validates :business_name, :cuit, uniqueness: true

  def to_s
    if self.business_name.present?
      [self.business_name, self.cuit].join(' - ') 
    else
      self.name
    end
  end

  alias_method :label, :to_s

  def as_json(options = nil)
    default_options = {
      only: [:id],
      methods: [:label]
    }

    super(default_options.merge(options || {}))
  end

  def validate_customer_kind
    if self.business_name.present?
      self.errors.add :cuit, :blank if self.cuit.blank?
    else
      self.errors.add :name, :blank if self.name.blank?
    end

  end

  def self.filtered_list(query)
    query.present? ? magick_search(query) : scoped
  end
end
