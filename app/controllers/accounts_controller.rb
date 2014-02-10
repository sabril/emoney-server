class AccountsController < InheritedResources::Base
  before_filter :authenticate_user!

  def top_up
    @account = Account.find params[:id]
    @transaction_log = @account.transaction_logs.build
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
    params.require(:transaction_log).permit([:amount])
  end
end
