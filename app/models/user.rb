class User < ActiveRecord::Base
  include RoleModel
  
  roles :admin, :regular
  
  has_paper_trail
  
  has_magick_columns name: :string, lastname: :string, email: :email
  
  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
    :validatable, authentication_keys: [:login]

  # Setup accessible (or protected) attributes for your model
  attr_accessor :login

  attr_accessible :name, :lastname, :email, :password, :password_confirmation,
    :role, :remember_me, :lock_version, :place_id, :username, :login

  # Defaul order
  default_scope order('lastname ASC')
  
  # Validations
  validates :name, :username, presence: true
  validates :name, :lastname, :username, :email, length: { maximum: 255 },
    allow_nil: true, allow_blank: true
  validates :username, uniqueness: { case_sensitive: false }

  belongs_to :place
  
  def initialize(attributes = nil, options = {})
    super(attributes, options)
    
    self.role ||= :regular
  end
  
  def to_s
    [self.name, self.lastname].compact.join(' ')
  end
  
  def role
    self.roles.first.try(:to_sym)
  end
  
  def role=(role)
    self.roles = [role]
  end
  
  def self.filtered_list(query)
    query.present? ? magick_search(query) : scoped
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(
        "LOWER(username) = :value OR LOWER(email) = :value", value: login.downcase
      ).first
    else
      where(conditions).first
    end
  end
end
