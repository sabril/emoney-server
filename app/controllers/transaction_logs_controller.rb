class TransactionLogsController < InheritedResources::Base
  before_filter :authenticate_user!

  def index
    @account = Account.find params[:account_id]
    @transaction_logs = @account.transaction_logs
  end
end
