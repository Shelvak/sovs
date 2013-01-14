class Seller < ActiveRecord::Base
  has_paper_trail

  attr_accessible :code, :name, :address, :phone

  validates :code, :name, presence: true
  validates :code, uniqueness: true

  has_many :sales

  def to_s
    ["[#{self.code}]", self.name].join(' ')
  end
end
