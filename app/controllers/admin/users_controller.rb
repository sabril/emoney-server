class Admin::UsersController < InheritedResources::Base
  before_filter :authenticate_user!
  load_and_authorize_resource :user
  
  protected
  def permitted_params
    params.permit(user: [:email, :first_name, :last_name, :phone, :identity_number, :password, :password_confirmation])
  end
end
