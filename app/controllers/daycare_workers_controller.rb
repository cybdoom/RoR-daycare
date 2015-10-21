class DaycareWorkersController < ApplicationController
  before_action :authenticate_worker!, except: [:login, :new, :create, :search_daycare, :select_department, :signup, :finish_signup]
  before_action :ensure_worker, except: [:login, :new, :create, :search_daycare, :select_department, :signup, :finish_signup]
  before_action :set_daycare, only: [:dashboard]
  before_action :set_worker, only: [:dashboard]


  def new
    @worker = Worker.new
  end

  def create
    @daycare = Daycare.find(params[:worker][:daycare_id])
    @worker = @daycare.workers.new(worker_params)
    if @worker.save
      flash[:success] = "Worker Successfully created."
      sign_in @worker
      redirect_to dashboard_daycare_worker_path(@worker)
    else
      render :new
    end
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
      @daycares = Daycare.where("name ILIKE ?", "%#{params[:q]}%")
    else
      @daycares = Daycare.all
    end
  end

  def select_department
    @daycare = Daycare.find(params[:daycare_id])
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
      flash[:success] = 'Signup Successfully!'
      sign_in @worker
      redirect_to dashboard_daycare_worker_path(@worker)
    else
      flash[:error] = 'Something went wrong! Please try again.'
      render :signup
    end
  end

  private
    def set_daycare
      @daycare = current_daycare
    end

    def set_worker
      @worker = current_daycare.workers.find(params[:id])
    end

    def worker_params
      # params[:worker].delete('daycare_id')
      params.require(:worker).permit!
    end

end
