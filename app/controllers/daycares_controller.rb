class DaycaresController < ApplicationController
  before_action :authenticate_manager!, only: [:show, :edit, :update, :add_departments, :congratulations]
  before_action :ensure_manager, only: [:show, :edit, :update, :add_departments]

  def new
    @daycare = Daycare.new
  end

  def create
    emails = User.all.map(&:email)
    @daycare = Daycare.new(daycare_params)
    unless emails.include?(@daycare.users.last.email)
      if @daycare.name.present? && @daycare.users.last && @daycare.users.last.email.present? && @daycare.save(validate: false)
        @daycare.roles.create(name: 'manager')
        flash[:notice] = "Daycare Successfully created."
        redirect_to add_departments_daycare_path(@daycare)
      else
        render :new
      end
    else
      flash[:notice] = "Email has already been taken"
      render :new
    end
  end

  def show
    
  end

  def edit
    @daycare_manager = @daycare.daycare_manager
  end

  def update
    params[:daycare][:users_attributes] = {}
    params[:daycare][:users_attributes]["0"] = params[:daycare][:user] if params[:daycare][:user]
    params[:daycare].delete(:user)
    if @daycare.update_attributes(daycare_params)
      flash[:notice] = "Daycare Successfully updated."
      redirect_to @daycare
    else
      flash[:error] = "Daycare Not updated."
      render :edit
    end
  end

  def login
    if request.post?
      @user = User.find_by(email: params[:email])
      if @user && @user.manager?
        if @user.valid_password?(params[:password])
          sign_in @user
          flash[:notice] = 'Signed in successfully'
          redirect_to @user.daycare
        else
          flash[:error] = 'Invalid email & password'
          render :login
        end
      else
        flash[:error] = 'Invalid email & password'
        render :login
      end
    else
      if current_user && current_user.manager?
        flash[:notice] = 'You are already logged in!'
        redirect_to current_user.daycare
      end
    end
  end

  def add_departments
    @daycare = Daycare.find(params[:id])
    @departments = @daycare.departments.build if @daycare.departments.blank?
    if request.post?
      daycare_params[:departments_attributes].values.each do |department|
        d = @daycare.departments.new(department_name: department['department_name'])
        d.save
      end
      redirect_to congratulations_daycare_path(@daycare)
    end
  end

  def congratulations
    
  end

  private

    def daycare_params
      params.require(:daycare).permit!
    end

    def authenticate_manager!
      unless current_user
        redirect_to login_daycares_path
      end
    end

    def ensure_manager
      unless current_user.manager? && current_user.daycare_id.to_s == params[:id]
        redirect_to root_path, alert: "You don't have permission to access this page!"
      end
    end
end
