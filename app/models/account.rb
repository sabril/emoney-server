class Account
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user
  embeds_many :transaction_logs

  field :balance, type: Float
  field :accn
  field :imei
  validates :accn, presence: true, uniqueness: true
  before_validation :set_accn
  has_many :syncs
  def self.columns
    self.fields.collect{|c| c[1]}
  end
  
  def set_accn(force=false)
    begin
      if _type == "Merchant"
        number = "1"
      else
        number = "2"
      end
      charset = %w{ 1 2 3 5 7 9}
      number = number + (0...13).map{ charset.to_a[rand(charset.size)] }.join  
    end while Account.where(:accn => number).exists?
    self.accn = number if self.new_record? || force
  end
end