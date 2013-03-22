class TransferProduct < ActiveRecord::Base
  has_paper_trail

  attr_accessible :place_id, :transfer_lines_attributes, :transfer_lines

  validate :must_have_one_item

  before_save :assign_total_price

  has_many :transfer_lines
  belongs_to :place

  accepts_nested_attributes_for :transfer_lines, allow_destroy: true,
    reject_if: ->(attrs) { attrs['product_id'].blank? }

  def initialize(attributes = nil, options = {})
    super(attributes, options)
    
    self.transfer_lines.build if self.transfer_lines.empty?
  end

  def must_have_one_item                                                        
    if self.transfer_lines.empty?
      self.errors.add :base, :must_have_one_item                                
    end                                                                         
  end

  def total_price
    self.transfer_lines.sum(&:line_price)
  end

  def assign_total_price
    self.total_price = total_price
  end
end
