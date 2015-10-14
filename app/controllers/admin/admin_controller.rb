class Admin::AdminController < ApplicationController
  before_action :authenticate_admin!, only: [:dashboard, :functionality, :select_privilege, :set_privilege]
  before_action :ensure_superadmin, only: [:dashboard, :functionality, :select_privilege, :set_privilege]
  
  def login
    if request.post?
      @user = User.find_by(email: params[:email])
      if @user && @user.superadmin?
        if @user.valid_password?(params[:password])
          sign_in @user
          flash[:notice] = 'Signed in successfully'
          redirect_to session[:previous_url] || admin_dashboard_path and return
        else
          flash[:error] = 'Invalid email & password'
          render :login
        end
      else
        flash[:error] = 'Unauthorized access!'
        redirect_to root_path
      end
    else
      if current_user && current_user.superadmin?
        flash[:notice] = 'You are already logged in!'
        redirect_to admin_dashboard_path
      end
    end
  end

  def fetch_customer_types
    country = ISO3166::Country.new(params[:country])
    country_name = country.name
    @customer_types = CustomerType.includes(:daycares).where('daycares.country =?', country_name).references(:daycare)
  end

  def fetch_customers
    if params[:customer_type_id]
      @customers = Daycare.where(customer_type_id: params[:customer_type_id])
    else
      @customers = Daycare.none
    end
  end

  def set_privilege
    # binding.pry
    if request.post?
    end
  end
  
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
