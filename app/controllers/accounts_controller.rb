class AccountsController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:register]
  skip_before_filter :verify_authenticity_token, only: :register, :if => Proc.new { |c| c.request.format == 'application/json' }

  def index
    @accounts = current_user.accounts
  end
  
  def top_up
    @account = Account.find params[:id]
    @transaction_log = @account.transaction_logs.build(log_type: "TopUp")
  end
  
  def register
    data = JSON.parse params[:data].to_s
    @account = Account.where(id: data["ACCN"], imei: data["HWID"]).first
    unless @account
      @error = "Account not found"
    else
      @account.update_attributes(imei: data["HWID"])
      @key = ServerSetting.first.key
    end
    respond_to do |format|
      format.json
    end
  end
  
  def process_top_up
    @account = Account.find params[:id]
    @transaction_log = @account.transaction_logs.build(top_up_params)
    if @transaction_log.save
      redirect_to account_transaction_logs_path @account
    else
      render :top_up
    end
  end
  
  def top_up_params
    params.require(:transaction_log).permit([:amount, :log_type])
  end
end
