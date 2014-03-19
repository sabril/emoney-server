class AccountsController < InheritedResources::Base
  before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token, only: :register, :if => Proc.new { |c| c.request.format == 'application/json' }

  def index
    @accounts = current_user.accounts
  end
  
  def top_up
    @account = Account.find params[:id]
    @transaction_log = @account.transaction_logs.build(log_type: "TopUp")
  end
  
  def register
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
