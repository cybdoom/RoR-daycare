class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  protect_from_forgery with: :exception

  def current_daycare
  	if current_user
  	  @current_daycare ||= current_user.daycare
  	else
  		nil
  	end
  end
  
  helper_method :current_daycare
end
