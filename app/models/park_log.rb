class ParkLog
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :accn
  field :licence
  field :time_in, type: DateTime
  field :time_out, type: DateTime
  field :status # in / out
  field :imei
  field :sesn
  field :park_key
  
  belongs_to :account
  before_validation :set_park_key
  
  def self.columns
    self.fields.collect{|c| c[1]}
  end
  
  def show_date
    Time.zone = "Jakarta"
    Time.zone.at(timestamp.to_i).strftime("%Y-%m-%d %H:%M")
  end
  
  def set_park_key(force=false)
    begin
      charset = %w{1 2 3 4 5 6 7 9}
      number = (0...9).map{ charset.to_a[rand(charset.size)] }.join  
    end while ParkLog.where(:park_key => number).exists?
    self.park_key = number if self.new_record? || force
  end
  
  def park_time
    time_out.present? ? (time_out.to_i - time_in.to_i) : 0
  end
  
  def amount
    (park_time.to_f / 1.hour.to_f).ceil * 2000 # 2000 per hour
  end
end