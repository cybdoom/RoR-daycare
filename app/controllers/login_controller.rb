class LoginController < ApplicationController

  def index
  end
  
  def login
    admin = Admin.find_by(email: params[:txtEmail])
    
    if admin && admin.authenticate(params[:txtPassword])
      login_admin(admin)
      redirect_to '/admin/dashboard'
    else
      flash[:danger] = "Invalid email/password combination"
      redirect_to root_url
    end
    
  end
  
  def logout
    log_out
    redirect_to root_url
  end
  
  def forgot_password
    admin = Admin.find_by(email: params["email"])
    
    if admin
      AdminMailer.forgot_password(admin).deliver
      
      flash[:info] = "Password reset link has been sent to your email"
      redirect_to '/login'
    else
      flash[:danger] = "Invalid email"
      redirect_to '/login'
    end
  end
  
  def password_reset
  end
  
  def do_reset
    if params["password"] == params["password_confirmation"]
      
      admin = Admin.find_by(email: params["email"])
      if admin && admin.password_digest[0..20] == params["token"] && admin.update_attributes(admin_params)
        flash[:success] = "Password updated. You can login using your new password"
        redirect_to '/login'
      else
        flash.now[:danger] = "Couldn't update. Verify your token."
        render 'password_reset'
      end
      
    else
      flash.now[:danger] = "Passwords do not match"
      render 'password_reset'
    end
  end


  private

    def admin_params
      params.permit(:password, :password_confirmation)
    end
    
end
