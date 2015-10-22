class DaycareWorkersController < ApplicationController
  before_action :authenticate_worker!, only: [:dashboard]
  before_action :ensure_worker, only: [:dashboard]
  before_action :set_daycare, only: [:dashboard]
  before_action :set_worker, only: [:dashboard]


  def new
    @worker = Worker.new
  end

  def login
    if request.post?
      @user = User.find_by(email: params[:email])
      path = login_user_and_set_redirect_path("worker")
      redirect_to path
    else
      if current_user && current_user.worker?
        flash[:success] = 'You are already logged in!'
        redirect_to dashboard_daycare_worker_path(current_user) 
      end
    end
  end

  def dashboard
  end

  # def set_password
  #   if request.post?
  #     @user = @worker
  #     path = password_and_set_redirect_path("worker")
  #     redirect_to path
  #   end
  # end

  def search_daycare
    if params[:q].present?
      @daycares = Daycare.where("lower(name) LIKE ?", "%#{params[:q].downcase}%")
    else
      @daycares = Daycare.all
    end
  end

  def select_department
    @daycare = Daycare.find(params[:cid])
    render :select_department
  end

  def signup
    @daycare = Daycare.find(params[:daycare_id])
    @department = Department.find(params[:department_id])
    @worker = Worker.new(daycare_id: @daycare.id, department_id: @department.id)
    render :signup
  end

  def finish_signup
    @worker = Worker.new(worker_params)
    if @worker.save
      RegistrationMailer.send_confirmation(@worker).deliver_later
      flash[:success] = 'Your account has been created Successfully. Please confirm your account!'
      redirect_to congratulations_daycare_workers_path
    else
      flash[:error] = 'Something went wrong! Please try again.'
      render :signup
    end
  end

  def congratulations
    
  end

  private
    def set_daycare
      @daycare = current_daycare
    end

    def set_worker
      @worker = current_daycare.workers.find(params[:id])
    end

    def worker_params
      params.require(:worker).permit!
    end

end
