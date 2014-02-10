class Account
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user
  embeds_many :transaction_logs

  field :balance, type: Float

  def self.columns
    self.fields.collect{|c| c[1]}
  end
end