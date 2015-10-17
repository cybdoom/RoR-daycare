class Admin::AdminController < ApplicationController
  before_action :authenticate_admin!, only: [:dashboard, :functionality, :select_privilege, :set_privilege]
  before_action :ensure_superadmin, only: [:dashboard, :functionality, :select_privilege, :set_privilege]
  
  def login
    if request.post?
      @user = User.find_by(email: params[:email])
      if @user && @user.superadmin?
        if @user.valid_password?(params[:password])
          sign_in @user
          flash[:success] = 'Signed in successfully'
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
        flash[:success] = 'You are already logged in!'
        redirect_to admin_dashboard_path
      end
    end
  end

  def fetch_customer_types
    @multi_select = params[:path] == 'admin_todos' ? true : true
    @path = params[:path]
    # countries_params = Array(params[:country])
    # countries= []
    # countries_params.each{|cp| countries << ISO3166::Country.new(cp)}
    # country_names = countries.collect(&:name)
    c = ISO3166::Country.new(params[:country])
    country_name = c.name
    @customer_types = CustomerType.includes(:daycares).where('daycares.country =? AND daycares.language =?', country_name, params[:language]).references(:daycare)
  end

  def fetch_customers
    @multi_select = params[:path] == 'admin_todos' ? true : false
    @path = params[:path]
    if params[:customer_type_id]
      @customers = Daycare.where(customer_type_id: params[:customer_type_id])
    else
      @customers = Daycare.none
    end
  end

  def set_privilege
    @daycare = Daycare.find(params[:daycare_id])
    if request.post?
      if params[:user_type].present?
        params[:user_type].join(' ').split(' ').each do |user_type|
          params[:permission_type].each do |permission_type|
            permission_type.constantize.create(daycare_id: @daycare.id, functionality_type: params[:functionality], user_type: user_type)
          end
        end
      end
      redirect_to admin_dashboard_path
    end
  end

  def todos    
  end
  
  private
    
end
