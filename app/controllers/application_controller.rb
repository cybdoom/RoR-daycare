class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  protect_from_forgery with: :exception
  after_filter :prepare_unobtrusive_flash
  # before_action :protect_from_devise_signin

  # def protect_from_devise_signin
  #   return unless request.get? 
  #   unless (request.path != "/users/sign_in" &&
  #       request.path != "/users/sign_up" &&
  #       !request.xhr?)
  #     redirect_to root_url
  #   end
  # end

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

    def authenticate_manager!
      unless current_user
        redirect_to login_daycares_path
      end
    end

    def authenticate_parent!
      unless current_user
        redirect_to login_daycare_parents_path
      end
    end

    def authenticate_worker!
      unless current_user
        redirect_to login_daycare_workers_path
      end
    end

    def ensure_superadmin
      unless current_user.superadmin?
        redirect_to root_path, alert: "You don't have authorization to access this page!"
      end
    end

    def ensure_manager
      unless current_user.manager?
        redirect_to root_path, alert: "You don't have authorization to access this page!"
      end
    end

    def ensure_worker
      unless current_user.worker?
        redirect_to root_path, alert: "You don't have authorization to access this page!"
      end
    end

    def ensure_parent
      unless current_user.parent?
        redirect_to root_path, alert: "You don't have authorization to access this page!"
      end
    end


  protected
    def login_user_and_set_redirect_path(role)
      if @user && check_role(role, @user)
        if @user.valid_password?(params[:password])
          sign_in @user
          flash[:success] = 'Signed in successfully'
          # redirect_to session[:previous_url] || admin_dashboard_path and return
          after_login_path_for(role, @user)
        else
          flash[:error] = 'Invalid email & password'
          relogin_path_for(role)
        end
      else
        flash[:error] = 'Unauthorized access!'
        root_path 
      end
    end

    def check_role(role, user)
      if role == "superadmin"
        user.superadmin?
      elsif role == "manager"
        user.manager?
      elsif role == "worker"
        user.worker?
      elsif role == "parent"
        user.parent?
      else
        false
      end
    end

    def after_login_path_for(role, user)
      if role == "superadmin"
        session[:previous_url] || admin_dashboard_path
      elsif role == "manager"
        daycare_path(user.daycare)
      elsif role == "worker"
        dashboard_daycare_worker_path(user)
      elsif role == "parent"
        dashboard_daycare_parent_path(user)
      else
        root_path
      end
    end

    def relogin_path_for(role)
      if role == "superadmin"
        admin_login_path
      elsif role == "manager"
        login_daycares_path
      elsif role == "worker"
        login_daycare_workers_path
      elsif role == "parent"
        login_daycare_parents_path
      else
        root_path
      end
    end
end
