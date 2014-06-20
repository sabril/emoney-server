class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  field :locked_at,       :type => Time

  field :first_name
  field :last_name
  field :identity_number
  field :address
  field :phone
  #field :public_key
  field :is_admin, type: Boolean, default: false
  field :authentication_token
  has_many :accounts, dependent: :destroy
  has_many :payers, dependent: :destroy
  has_many :merchants, dependent: :destroy
  has_many :attendance_machines, dependent: :destroy
  has_many :park_meters, dependent: :destroy

  before_save :ensure_authentication_token
  after_create :create_payer_account, :create_merchant_account
  accepts_nested_attributes_for :accounts
  def self.columns
    self.fields.collect{|c| c[1]}
  end

  def create_payer_account(balance=0.0)
    payers.create(balance: balance, name: "Example Payer")
  end

  def create_merchant_account(balance=0.0)
    merchants.create(balance: balance, name: "Example Merchant")
  end
  
  def create_attendance_machine_account
    attendance_machines.create
  end
  
  def create_park_meter_account
    park_meters.create
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  private
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
