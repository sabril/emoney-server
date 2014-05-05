class PresenceLog
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :accn
  field :timestamp
  field :imei
  field :sesn
  
  belongs_to :account
  
  def self.columns
    self.fields.collect{|c| c[1]}
  end
  
  def show_date
    Time.zone = "Jakarta"
    Time.zone.at(timestamp.to_i).strftime("%Y-%m-%d %H:%M")
  end
end