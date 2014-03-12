class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :update_sanitized_params, if: :devise_controller?
  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:first_name, :last_name, :identity_number, :address, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:first_name, :last_name, :identity_number, :address, :email, :password, :current_password, :password_confirmation)}
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to "/", :alert => exception.message
  end

  rescue_from ActiveRecord::RecordNotFound do
    render :not_found
  end

  private
  def authenticate_user_from_token!
    user_email = params[:user_email].presence
    user       = user_email && User.find_by_email(user_email)
    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
      sign_in user, store: false
    end
  end
end
