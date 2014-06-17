class ParkLogsController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:park]
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  
  def park
    # park in or out?
    respond_to do |format|
      format.json
    end
  end
  
  def index
    @account = Account.find params[:account_id]
    @park_logs = @account.park_logs.order_by("created_at desc").page(params[:page]).per(10)
  end
end