require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :authenticate_user!

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit :username, :email, :password, :password_confirmation
    end

    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:username, :email, :password, :password_confirmation,
               :current_password)
    end

    devise_parameter_sanitizer.for(:accept_invitation)
                              .concat [:first_name, :last_name, :phone]

    devise_parameter_sanitizer.for(:accept_invitation) do |u|
      u.permit(:first_name, :last_name, :phone, :password,
               :password_confirmation, :invitation_token)
    end
  end

  def authorize_admin!
    return true if current_user.admin?
    alert = 'Du hast keine Berechtigung für den Admin Bereich!'
    redirect_to(:root, alert: alert) && return
  end
end
