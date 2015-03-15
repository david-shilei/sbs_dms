class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  #before_filter :permitted_categories

  # Add permission methods for documents and categories
  include Permissions

  # Selection of categories the current user can view in the tree navigation
=begin
  def permitted_categories
    @permitted_categories = upload_permitted_categories
  end
=end
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :group_id, :password, :password_confirmation) }
  end
  
end 