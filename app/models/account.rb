class Account
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user
  embeds_many :transaction_logs

  field :balance, type: Float
  field :accn
  field :imei
  validates :accn, presence: true, uniqueness: true
  before_save :set_accn
  def self.columns
    self.fields.collect{|c| c[1]}
  end
  
  def set_accn(force=false)
    begin
      number = ""
      charset = %w{ 1 2 3 5 7 9}
      number = (0...12).map{ charset.to_a[rand(charset.size)] }.join
    end while Account.where(:accn => number).exists?
    self.accn = number if self.new_record? || force
  end
end