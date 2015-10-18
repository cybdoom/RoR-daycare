class DaycaresController < ApplicationController
  before_action :authenticate_manager!, only: [
                                            :show, :edit, :update, 
                                            :add_departments, 
                                            :congratulations, 
                                            :invite_workers,
                                            :invite_parents
                                          ]
  before_action :ensure_manager, only: [
                                     :show, :edit, :update, 
                                     :add_departments,
                                     :congratulations,
                                     :invite_workers,
                                     :invite_parents
                                    ]
  before_action :set_daycare, only: [
                                  :edit, :show, :update, 
                                  :add_departments, 
                                  :congratulations,
                                  :invite_workers,
                                  :invite_parents
                                ]

  def new
    @daycare = Daycare.new
  end

  def create
    @daycare = Daycare.new(daycare_params)
    country = ISO3166::Country.new(params[:daycare][:country])
    @daycare.country = country.name
    if @daycare.save
      flash[:success] = "Daycare Successfully created."
      sign_in @daycare.manager
      redirect_to add_departments_daycare_path(@daycare)
    else
      render :new
    end
  end

  def show
  end

  def edit
    @daycare_manager = @daycare.manager
  end

  def update
    if @daycare.update(daycare_params)
      flash[:success] = "Daycare Successfully created."
      sign_in @daycare.manager
      redirect_to add_departments_daycare_path(@daycare)
    else
      render :new
    end
  end

  def login
    if request.post?
      @user = User.find_by(email: params[:email])
      path = login_user_and_set_redirect_path("manager")
      redirect_to path
      # if @user && @user.manager?
      #   if @user.valid_password?(params[:password])
      #     sign_in @user
      #     flash[:success] = 'Signed in successfully'
      #     redirect_to @user.daycare
      #   else
      #     flash[:error] = 'Invalid email & password'
      #     render :login
      #   end
      # else
      #   flash[:error] = 'Invalid email & password'
      #   render :login
      # end
    else
      if current_user && current_user.manager?
        flash[:success] = 'You are already logged in!'
        redirect_to current_user.daycare
      end
    end
  end

  def add_departments
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

  def invite_workers
    if request.post?
      DaycareMailer.send_invite_to_workers(params[:email_ids], @daycare).deliver_now
      flash[:success] = 'Invitation to daycare workers has been sent successfully!'
      redirect_to invite_parents_daycare_path(@daycare)
    end
  end

  def invite_parents
    if request.post?
      DaycareMailer.send_invite_to_parents(params[:email_ids], @daycare).deliver_now
      flash[:success] = 'Invitation to daycare parents has been sent successfully!'
      redirect_to @daycare
    end
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

    def set_daycare
      @daycare = Daycare.find(params[:id])
    end
end
