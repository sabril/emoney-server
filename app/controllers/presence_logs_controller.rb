class PresenceLogsController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:presence]
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  
  def presence
    account = Account.where(accn: params[:accn]).first
    reader = Account.where(imei: params[:imei]).first
    if account && reader
      account.presence_logs.create(accn: account.accn, imei: reader.imei, timestamp: params[:timestamp])
    else
      @error = "Invalid presence"
    end
    respond_to do |format|
      format.json
    end
  end
end