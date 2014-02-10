class TransactionLog
  include Mongoid::Document
  embedded_in :account

  field :amount, type: Float
  field :log_type
  field :payer_id, type: Integer
  field :merchant_id, type: Integer
  field :timestamp, type: Integer
  field :cancel, type: Boolean
  field :status, default: String

  def self.columns
    self.fields.collect{|c| c[1]}
  end
end