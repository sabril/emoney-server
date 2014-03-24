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
    else
      account = Account.where(accn: header["ACCN"].to_s).first
      @sync = Sync.new(data: params[:data], header: params[:header], logs: params[:logs], hashed_logs: signature)
      if @sync.save
        if account
          logs = JSON.parse(logs_row)
          logs.each do |log|
            # check merchant & payer
            merchant = Merchant.where(id: log["ACCN-R"]).first
            payer = Payer.where(id: log["ACCN-S"]).first
            if merchant && payer
              merchant.transaction_logs.create(
                merchant_id: log["ACCN-R"],
                payer_id: log["ACCN-S"],
                amount: log["AMNT"],
                log_type: log["PT"],
                timestamp: log["TS"],
                status: log["STAT"],
                cancel: log["CNL"],
                num: log["NUM"],
                binary_id: log["BinaryID"]
              )
              
              payer.transaction_logs.create(
                merchant_id: log["ACCN-R"],
                payer_id: log["ACCN-S"],
                amount: -(log["AMNT"]),
                log_type: log["PT"],
                timestamp: log["TS"],
                status: log["STAT"],
                cancel: log["CNL"],
                num: log["NUM"],
                binary_id: log["BinaryID"]
              )
            else
              @error = "Invalid Transactions"
            end
          end
        else
          @error = "Account not found"
        end
      else
        @error = "Duplicate Transaction"
      end
    end
    @key = ServerSetting.first.key
    respond_to do |format|
      format.json
      format.html
    end
  end
end
