class Seller < ActiveRecord::Base
  has_paper_trail

  attr_accessible :code, :name, :address, :phone

  validates :code, :name, presence: true
  validates :code, uniqueness: true

  def to_s
    [self.name, self.code].join(' - ')
  end
end
