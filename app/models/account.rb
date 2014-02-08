class Account
  include Mongoid::Document
  belongs_to :user
  embeds_many :transaction_logs

  field :balance, type: Float
end