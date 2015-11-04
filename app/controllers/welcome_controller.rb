class WelcomeController < ApplicationController
  def index
  	if current_user
  		if current_user.superadmin?
        redirect_to admin_dashboard_path
  		elsif current_user.manager?
  			redirect_to current_daycare
  		elsif current_user.parent?
  			redirect_to dashboard_daycare_parent_path(current_user)
  		elsif current_user.worker?
  			redirect_to dashboard_daycare_worker_path(current_user)
  		end  				
  	end
  end
end
