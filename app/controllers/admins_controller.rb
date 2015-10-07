class AdminsController < ApplicationController
  before_action :authorize
  
  def edit
    @admin = Admin.find(params[:id])
  end
  
  def update
    @admin = Admin.find(params[:id])
    if @admin.update_attributes(admin_params)
      flash[:success] = "Profile updated"
      redirect_to '/home'
    else
      render 'edit'
    end
  end

  def dashboard
  	
  end
  
  private

    def admin_params
      params.require(:admin).permit(:name, :email, :password, :password_confirmation)
    end
  
end
