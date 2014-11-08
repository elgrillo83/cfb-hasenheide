class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit :username, :email, :password, :password_confirmation
    end

    devise_parameter_sanitizer.for(:accept_invitation).concat [:first_name, :last_name, :phone]

    devise_parameter_sanitizer.for(:accept_invitation) do |u|
      u.permit(:first_name, :last_name, :phone, :password, :password_confirmation,
               :invitation_token)
    end
  end
end
