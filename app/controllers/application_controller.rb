class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  protect_from_forgery with: :exception
  before_action :protect_from_devise_signin

  def protect_from_devise_signin
    return unless request.get? 
    unless (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        !request.xhr?)
      redirect_to root_url
    end
  end

  def current_daycare
  	if current_user
  	  @current_daycare ||= current_user.daycare
  	else
  		nil
  	end
  end
  helper_method :current_daycare


  private
    def authenticate_admin!
      unless current_user
        redirect_to admin_login_path
      end
    end

    def ensure_superadmin
      unless current_user.superadmin?
        redirect_to root_path, alert: "You don't have authorization to access this page!"
      end
    end
end
