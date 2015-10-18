class DaycareWorkersController < ApplicationController
  before_action :authenticate_worker!, except: [:login, :new, :create]
  before_action :ensure_worker, except: [:login, :new, :create]
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

  private
    def set_daycare
      @daycare = current_daycare
    end

    def set_worker
      @worker = current_daycare.workers.find(params[:id])
    end

    def worker_params
      params[:worker].delete('daycare_id')
      params.require(:worker).permit!
    end

end
