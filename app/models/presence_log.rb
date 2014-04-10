class PresenceLog
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :accn
  field :timestamp
  field :imei
  
  belongs_to :account
  
  def self.columns
    self.fields.collect{|c| c[1]}
  end
end