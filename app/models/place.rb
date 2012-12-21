class Place < ActiveRecord::Base
  has_paper_trail

  attr_accessible :description

  validates :description, presence: true
  validates :description, uniqueness: true

  has_many :users

  def to_s
    self.description
  end
end
