class Sale < ActiveRecord::Base
  has_paper_trail

  attr_accessor :seller_code, :auto_customer_name, :default_price_type

  scope :between, ->(_from, _to) { where(
    created_at: _from.._to
  ) }
  scope :in_day, ->(day) { between(
    day.to_time.beginning_of_day, day.to_time.end_of_day
  ) }
  scope :in_month, ->(month) { between(
    month.to_time.beginning_of_month, month.to_time.end_of_month
  ) }
  scope :positives, ->() { where("total_price > 0") }

  before_validation :manual_validate
  before_save :recalc_price
  after_create :discount_sold_stock, :send_to_print

  validates :seller_code, :total_price, presence: true
  validates :sale_kind, length: { maximum: 1 }
  validates :total_price, numericality: { allow_nil: true, allow_blank: true }
  validate :must_have_one_item

  belongs_to :seller
  belongs_to :customer
  has_many :product_lines, inverse_of: :sale, dependent: :destroy

  accepts_nested_attributes_for :product_lines, allow_destroy: true,
    reject_if: ->(attributes) { attributes['product_id'].blank? }

  def manual_validate
    if self.auto_customer_name.present? && self.customer_id.blank?
      self.errors.add :auto_customer_name, I18n.t('view.sales.wait_for_customer')
    end

    if self.seller_code.present?
      seller = Seller.find_by_code(self.seller_code)
      if seller
        self.seller_id = seller.id
      else
        self.errors.add :seller_code, I18n.t('view.sales.seller_not_found')
      end
    end
  end

  def must_have_one_item
    if self.product_lines.reject(&:marked_for_destruction?).size < 1
      self.errors.add :base, :must_have_one_item
    end
  end

  def discount_sold_stock
    self.product_lines.each do |pl|
      pl.product.put_to_stock(-pl.quantity)
    end
  end

  def send_to_print
    #Printer.print_tax(self)
  end

  def common_bill?
    self.sale_kind == 'B'
  end

  def created_at_date
    self.created_at.to_date
  end

  def self.stats_by_seller_between(from, to)
    stats = {}
    between(from, to).group_by(&:seller_id).each do |seller, sales|
      sales_sum = sales.sum(&:total_price)

      stats[Seller.find(seller).to_s] = [
        sales.delete_if { |s| s.revoked || s.total_price <= 0 }.size,
        sales_sum
      ]
    end

    stats
  end

  def self.earn_between(from, to)
    between(from, to).group_by(&:created_at_date).map do |day, sales|
      [day, sales.sum(&:total_price)]
    end
  end

  def self.payrolls_of_month(date)
    if date
      date = Date.parse(date)
      from, to = date.beginning_of_month.to_date, date.end_of_month.to_date
      payrolls_pack = {}
      payrolls_resume = {}

      (from..to).each do |d|
        payrolls_pack[d] = []
        between(
          d.beginning_of_day, d.end_of_day
        ).group_by(&:seller_id).each do |seller, sales|
          sales_sum = sales.sum(&:total_price)
          payrolls_pack[d] << [
            Seller.find(seller).code,
            sales.delete_if { |s| s.revoked || s.total_price <= 0 }.count,
            sales_sum
          ]
        end
      end

      between(
        from.beginning_of_day, to.end_of_day
      ).group_by(&:seller_id).each do |seller, sales|

        payrolls_resume[Seller.find(seller).code] = sales.sum(&:total_price)
      end

      { stats: payrolls_pack, resume: payrolls_resume }
    end
  end

  def revoke!
    Sale.transaction do
      self.product_lines.each do |p_l|
        prod = p_l.product
        prod.total_stock += p_l.quantity
        prod.save!
      end

      self.update_column(:revoked, true)
    end
  end

  def revoked?
    self.revoked
  end

  def recalc_price
    self.total_price = self.product_lines.each do |pl|
      price = pl.product.send(pl.price_type)
      pl.unit_price = self.common_bill? ? price : (price / 1.21)
      pl.price = pl.unit_price * pl.quantity
    end.sum(&:price)

    self.total_price *= 1.21 unless self.common_bill?
  end
end
