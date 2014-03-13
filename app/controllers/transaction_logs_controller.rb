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
    @sync = Sync.new(data: params[:data])
    @key = SecureRandom.hex(32)
    @sync.save
    respond_to do |format|
      format.json
      format.html
    end
  end
end
