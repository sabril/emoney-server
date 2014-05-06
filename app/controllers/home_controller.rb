class HomeController < ApplicationController
  def index
  end
  
  def update_key
    ServerSetting.first.update_key
    redirect_to dashboard_path, notice: "Server Key updated"
  end
end
