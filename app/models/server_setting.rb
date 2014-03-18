class ServerSetting
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :key
  
  def update_key
    update_attributes(key: SecureRandom.hex(32))
  end
end