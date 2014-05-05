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
  field :cancel, type: Boolean, default: false
  field :status, type: String, default: 0
  field :num, type: Integer
  field :binary_id
  
  validate :check_account_balance
  after_create :update_account_balance
  def self.columns
    self.fields.collect{|c| c[1]}
  end

  def check_account_balance
    if (account.balance + amount) < 0
      errors.add(:amount, "Account balance is not enough for this transaction's amount")
    end
  end
  
  def update_account_balance
    account.balance += amount
    account.save(validate: false)
  end
  
  def merchant
    Account.where(accn: merchant_id.to_s).first
  end
  
  def payer
    Account.where(accn: payer_id.to_s).first
  end
  
  def show_date
    Time.zone = "Jakarta"
    Time.zone.at(timestamp.to_i).strftime("%Y-%m-%d %H:%M")
  end
  
  def cancel_transaction
    unless cancel
      # cek merchant atau payer
      if account.is_merchant?
        merchant.transaction_logs.create(amount: -(amount), payer_id: payer_id, merchant_id: merchant_id, timestamp: Time.now.to_i, cancel: true, status: "completed", num: "1")
        payer.transaction_logs.create(amount: amount, payer_id: payer_id, merchant_id: merchant_id, timestamp: Time.now.to_i, cancel: true, status: "completed", num: "1")
      elsif account.is_payer?
        merchant.transaction_logs.create(amount: amount, payer_id: payer_id, merchant_id: merchant_id, timestamp: Time.now.to_i, cancel: true, status: "completed", num: "1")
        payer.transaction_logs.create(amount: -(amount), payer_id: payer_id, merchant_id: merchant_id, timestamp: Time.now.to_i, cancel: true, status: "completed", num: "1")
      end
    end
  end
end