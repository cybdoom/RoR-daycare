class PasswordsController < ApplicationController

  def set_manager_password
    @user = User.find_by_email(params[:email])
    @role = "manager"
  end

  def set_worker_password
    @user = User.find_by_email(params[:email])
    @role = "worker"
  end

  def set_parent_password
    @user = User.find_by_email(params[:email])
    @role = "parent"
  end

  def set_password     
    @user = User.find(params[:id])
    if request.post?
      path = password_and_set_redirect_path(params[:role])
      redirect_to path
    end
  end

  private
    def set_daycare
      @daycare = current_daycare
    end


    def get_password_set_path(role, user)
      if role == "superadmin"
        '#'
      elsif role == "manager"
        set_manager_password_password_path(user, email: user.email)
      elsif role == "worker"
        set_worker_password_password_path(user, email: user.email)
      elsif role == "parent"
        set_parent_password_password_path(user, email: user.email)
      else
        root_path
      end
    end


    def password_and_set_redirect_path(role)
      if params[:password] == params[:password_confirmation]
        if @user.update_attribute(:password, params[:password])
          sign_in @user
          flash[:success] = 'Password Successfully Set'
          after_login_path_for(role, @user)
        else
          flash[:success] = "Can't set your password"
          get_password_set_path(role, @user)
        end
      else
        flash[:alert] = "Password doesn't match"
        get_password_set_path(role, @user)
      end
    end


end
