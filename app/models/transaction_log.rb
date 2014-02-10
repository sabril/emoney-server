class TransactionLog
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  embedded_in :account

  field :amount, type: Float
  field :log_type
  field :payer_id, type: Integer
  field :merchant_id, type: Integer
  field :timestamp, type: Integer
  field :cancel, type: Boolean
  field :status, type: String, default: "unsync"
  
  validate :check_account_balance
  after_save :update_account_balance
  def self.columns
    self.fields.collect{|c| c[1]}
  end

  def check_account_balance
    
  end
  
  def update_account_balance
    account.balance += amount
    account.save
  end
end