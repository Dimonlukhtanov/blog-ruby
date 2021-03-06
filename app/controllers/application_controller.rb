class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  add_flash_types :success, :danger, :info, :warning

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:username, :email, :password)
    end

    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:username, :email, :password, :current_password)
    end
  end
end
