class Place < ActiveRecord::Base
  has_paper_trail

  #attr_accessible :description, :transfer_default

  validates :description, presence: true
  validates :description, uniqueness: true

  has_many :users

  before_save :keep_only_one_transfer_default

  def to_s
    self.description
  end

  def self.transfer_default
    where(transfer_default: true).first
  end

  def keep_only_one_transfer_default
    if self.transfer_default && Place.transfer_default &&
      Place.transfer_default != self

      Place.transfer_default.update_attributes(transfer_default: false)
    end
  end
end
