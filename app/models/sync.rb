class Sync
  include Mongoid::Document
  include Mongoid::Timestamps

  field :data
  field :ip_address
  field :header
  field :logs
  field :hashed_logs
  
  validates :hashed_logs, presence: true, uniqueness: true
  def self.columns
    self.fields.collect{|c| c[1]}
  end
end