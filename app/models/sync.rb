class Sync
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :account
  field :data
  field :ip_address
  field :header
  field :logs
  field :hashed_logs
  field :error_logs
  
  validates :hashed_logs, presence: true#, uniqueness: {scope: :account_id} # check for reply attack
  def self.columns
    self.fields.collect{|c| c[1]}
  end
end