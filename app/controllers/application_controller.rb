class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :update_sanitized_params, if: :devise_controller?
  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:first_name, :last_name, :identity_number, :address, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:first_name, :last_name, :identity_number, :address, :email, :password, :current_password, :password_confirmation)}
  end

end
