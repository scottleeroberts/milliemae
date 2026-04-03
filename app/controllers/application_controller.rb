class ApplicationController < ActionController::Base
  allow_browser versions: :modern unless Rails.env.test?

  stale_when_importmap_changes

  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def require_creator!
    redirect_to root_path, alert: "Not authorized." unless current_user&.creator? || current_user&.admin?
  end

  def require_admin!
    redirect_to root_path, alert: "Not authorized." unless current_user&.admin?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :bio, :instagram, :etsy, :pinterest, :website, :facebook])
  end
end
