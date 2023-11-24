# frozen_string_literal: true

# app/controlllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Pundit::Authorization
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError do
    redirect_to root_url, alert: 'You do not have permission to carry out this action.'
  end

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to root_url, alert: 'Record not found!'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[full_name email])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[full_name email])
  end
end
