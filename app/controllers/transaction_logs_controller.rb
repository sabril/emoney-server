class TransactionLogsController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:sync]
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  def index
    @account = Account.find params[:account_id]
    @transaction_logs = @account.transaction_logs
  end
  
  def show
    @account = Account.find params[:account_id]
    @transaction_log = @account.transaction_logs.find params["id"]
  end

  def sync
    header = JSON.parse params[:header]
    logs_row = params[:logs]
    signature = header["signature"]
    last_sync_at = header["last_sync_at"]
    if signature != Digest::SHA256.hexdigest(logs_row).upcase
      @error = "Hash not match"
    end
    @sync = Sync.new(data: params[:data], header: params[:header], logs: params[:logs])
    @key = ServerSetting.first.key
    @sync.save
    respond_to do |format|
      format.json
      format.html
    end
  end
end
