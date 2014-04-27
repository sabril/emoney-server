class AccountsController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:register]
  skip_before_filter :verify_authenticity_token, only: :register, :if => Proc.new { |c| c.request.format == 'application/json' }

  def index
    @accounts = current_user.accounts.order_by("updated_at desc").page(params[:page]).per(10)
    #@accounts = Account.order_by("updated_at desc").page(params[:page]).per(10)
  end
  
  def top_up
    @account = Account.find params[:id]
    @transaction_log = @account.transaction_logs.build(log_type: "TopUp")
  end
  
  def create_account
    if params["account"] == "merchant"
      account = current_user.create_merchant_account
    elsif params["account"] == "payer"
      account = current_user.create_payer_account
    else
      account = current_user.create_attendance_machine_account
    end
    redirect_to account
  end
  
  def register
    data = JSON.parse params[:data].to_s
    @account = Account.where(accn: data["ACCN"].to_s).first
    @server = ServerSetting.first
    if @account
      if @account.imei.present?
        @error = "Already registered"
      else
        @account.update_attributes(imei: data["HWID"].to_s)
        @key = ServerSetting.first.key
      end
    else
      @error = "Account not found"
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
  
  private

  def permitted_params
    params.permit(account: [:imei, :accn, :balance, :_type, :name])
  end
end
