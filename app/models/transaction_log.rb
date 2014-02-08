class TransactionLog
  include Mongoid::Document
  embedded_in :account

  field :amount, type: Float
  field :payer_id, type: Integer
  field :merchant_id, type: Integer
  field :timestamp, type: Integer
  field :cancen, type: Boolean
  field :status, default: String
end