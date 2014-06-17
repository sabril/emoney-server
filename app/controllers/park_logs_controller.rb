class ParkLogsController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:park]
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  
  def park
    account = Account.where(accn: params["ACCN"].to_s).first
    if account
      # park in or out?
      # check last park_log
      last_park_log = account.park_logs.last
      unless last_park_log
        # new vehicle park in
        last_park_log = account.park_logs.create(accn: params["ACCN"], licence: params["licence"].to_s, status: "in", time_in: Time.now)
        @status = "in"
        @park_key = last_park_log.park_key
      else
        unless last_park_log.status == "out"
          # get park key
          if params["park_key"].present?
            if last_park_log.park_key == params["park_key"]
              last_park_log.update_attributes(status: "out", time_out: Time.now)
              # vehicle out
              @status = "out"
              @amount = account.park_logs.last.amount
            else
              @error = "Wrong key!"
            end
          else
            @error = "No key"
          end
        else
          # vehicle in
          @status = "in"
          last_park_log = account.park_logs.create(accn: params["ACCN"], licence: params["licence"].to_s, status: "in", time_in: Time.now)
          @park_key = last_park_log.park_key
        end
      end
    else
      @error = "Vehicle not found"
    end
    respond_to do |format|
      format.json
    end
  end
  
  def index
    @account = Account.find params[:account_id]
    @park_logs = @account.park_logs.order_by("created_at desc").page(params[:page]).per(10)
  end
end