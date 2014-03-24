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
    # @account = Account.where(accn: data["ACCN"].to_s, imei: data["HWID"].to_s).first
    # unless @account
    #   @account = Account.where(accn: data["ACCN"].to_s).first
    #   if @account
    #     @account.update_attributes(imei: data["HWID"].to_s)
    #   else
    #     @error = "Account not found"
    #   end
    # else
    #   @key = ServerSetting.first.key
    # end
    @account = Account.where(accn: data["ACCN"].to_s).first
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
    params.permit(account: [:imei, :accn])
  end
end
