class TransactionLogsController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:sync]
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  def index
    @account = Account.find params[:account_id]
    @transaction_logs = @account.transaction_logs.order_by("created_at desc").page(params[:page]).per(10)
  end
  
  def show
    @account = Account.find params[:account_id]
    @transaction_log = @account.transaction_logs.find params["id"]
  end

  def sync
    header = JSON.parse params[:header]
    logs_row = params[:logs]
    signature = header["signature"]
    last_sync_at = header["last_sync_at"].to_i # to generate new key
    start_balance = header["balance"]
    @error_logs = []
    if signature != Digest::SHA256.hexdigest(logs_row).upcase
      @error = "Hash not match"
    else
      account = Account.where(accn: header["ACCN"].to_s).first
      @sync = Sync.new(account: account, data: params[:data], header: params[:header], logs: params[:logs], hashed_logs: signature)
      if @sync.save
        if account
          logs = JSON.parse(logs_row)
          logs.each do |log|
            # check merchant & payer
            if header["ACCN"].to_s[0] == "1"
              merchant = Merchant.where(accn: header["ACCN"].to_s).first
              payer = Payer.where(accn: log["ACCN-P"].to_s).first
              if merchant && payer
                # cari timestamp kalau ketemu update log / tidak create log
                log_payer = payer.transaction_logs.where(timestamp: log["TS"]).first
                if log_payer
                  log_payer.merchant_id = log["ACCN-M"]
                  log_payer.status = "completed"
                else
                  log_payer = payer.transaction_logs.build(
                    merchant_id: log["ACCN-M"],
                    payer_id: log["ACCN-P"],
                    amount: -(log["AMNT"]),
                    log_type: log["PT"],
                    timestamp: log["TS"],
                    status: log["STAT"],
                    cancel: log["CNL"],
                    num: log["NUM"],
                    binary_id: log["BinaryID"]
                  )
                end
                if log_payer.valid? && log_payer.save
                  log_merchant = merchant.transaction_logs.where(timestamp: log["TS"]).first
                  unless log_merchant
                    log_merchant = merchant.transaction_logs.create(
                      merchant_id: log["ACCN-M"],
                      payer_id: log["ACCN-P"],
                      amount: log["AMNT"],
                      log_type: log["PT"],
                      timestamp: log["TS"],
                      status: "completed",
                      cancel: log["CNL"],
                      num: log["NUM"],
                      binary_id: log["BinaryID"]
                    )
                  end
                else
                  # better error
                  @error = "Error Payer: #{log_payer.errors.messages}"
                  @error_logs << log["NUM"]
                end
              else
                # need to block
                @error = "Invalid Transactions"
              end
            else
              # 2
              payer = Payer.where(accn: header["ACCN"].to_s).first
              merchant = Merchant.where(accn: log["ACCN-M"].to_s).first
              if payer
                # cari timestamp kalau ketemu update log / tidak create log
                log_payer = payer.transaction_logs.where(timestamp: log["TS"]).first
                if log_payer
                  log_payer.merchant_id = log["ACCN-M"]
                else
                  log_payer = payer.transaction_logs.build(
                    merchant_id: log["ACCN-M"],
                    payer_id: log["ACCN-P"],
                    amount: -(log["AMNT"]),
                    log_type: log["PT"],
                    timestamp: log["TS"],
                    status: log["STAT"],
                    cancel: log["CNL"],
                    num: log["NUM"],
                    binary_id: log["BinaryID"]
                  )
                  if log_payer.valid? && log_payer.save && header["QR"] == "1"
                    log_merchant = merchant.transaction_logs.where(timestamp: log["TS"]).first
                    unless log_merchant
                      log_merchant = merchant.transaction_logs.create(
                        merchant_id: log["ACCN-M"],
                        payer_id: log["ACCN-P"],
                        amount: log["AMNT"],
                        log_type: log["PT"],
                        timestamp: log["TS"],
                        status: "completed",
                        cancel: log["CNL"],
                        num: log["NUM"],
                        binary_id: log["BinaryID"]
                      )
                    end
                  end
                end
              else
                # need to block
                @error = "Invalid Transactions"
              end
            end
          end
          log_payer = nil
          log_merchant = nil
        else
          @error = "Account not found"
        end
      else
        @error = "Duplicate Transaction"
      end
    end
    @sync.error_logs = @error if @error
    @sync.save
    @server = ServerSetting.first
    @renew_key = false
    if last_sync_at < @server.updated_at.to_i
      @renew_key = true
      @key = @server.key
    end
    @account_balance = Account.where(accn: header["ACCN"].to_s).first.balance.to_i if account
    respond_to do |format|
      format.json
      format.html
    end
  end
  
  def presence
    
  end
  
  def cancel
    @account = Account.find params[:account_id]
    @transaction_log = @account.transaction_logs.find params[:id]
    @transaction_log.cancel_transaction
    redirect_to account_transaction_logs_path(@account), notice: "Transaction has been cancelled"
  end
end
