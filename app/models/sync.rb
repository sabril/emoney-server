class Sync
  include Mongoid::Document
  include Mongoid::Timestamps

  field :data
  field :ip_address
  def self.columns
    self.fields.collect{|c| c[1]}
  end
end