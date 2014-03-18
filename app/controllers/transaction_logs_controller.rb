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
    # cek dulu key apakah perlu update
    server_setting = ServerSetting.first
    json_data = param[:data].to_json
    client_last_sync_at = json_data["header"]["last_sync_at"].to_time
    @update_key = false
    if server_setting.updated_at.to_i > client_last_sync_at.to_i
      @update_key = true
    end
    @key = server_setting.key
    
    
    @sync = Sync.create({data: json_data})
    respond_to do |format|
      format.json
      format.html
    end
  end
end
