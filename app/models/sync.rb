class Sync
  include Mongoid::Document
  include Mongoid::Timestamps

  field :data
  def self.columns
    self.fields.collect{|c| c[1]}
  end
end