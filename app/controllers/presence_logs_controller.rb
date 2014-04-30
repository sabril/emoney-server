class PresenceLogsController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:presence]
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  
  def presence
    account = Account.where(accn: params["ACCN-P"].to_s).first
    reader = Account.where(accn: params["ACCN-M", imei: params["HWID"]].to_s).first
    if account && reader
      reader.presence_logs.create(accn: account.accn, imei: reader.imei, timestamp: params[:timestamp])
    else
      @error = "Invalid presence"
    end
    respond_to do |format|
      format.json
    end
  end
  
  def index
    @account = Account.find params[:account_id]
    @presence_logs = @account.presence_logs.order_by("created_at desc").page(params[:page]).per(10)
  end
end