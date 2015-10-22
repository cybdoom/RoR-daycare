class DaycareParentsController < ApplicationController
  before_action :authenticate_parent!, except: [:login, :new, :create]
  before_action :ensure_parent, except: [:login, :new, :create]
  before_action :set_daycare, only: [:dashboard]
  before_action :set_parent, only: [:dashboard]

  def new
    @parent = Parent.new
  end

  def create
    @daycare = Daycare.find(params[:parent][:daycare_id])
    @parent = @daycare.parents.new(parent_params)
    if @parent.save
      flash[:success] = "Parent Successfully created."
      RegistrationMailer.send_confirmation(@worker).deliver_later
      redirect_to dashboard_daycare_parent_path(@parent)
    else
      render :new
    end
  end

  def login
    if request.post?
      @user = User.find_by(email: params[:email])
      path = login_user_and_set_redirect_path("parent")
      redirect_to path
    else
      if current_user && current_user.parent?
        flash[:success] = 'You are already logged in!'
        redirect_to dashboard_daycare_parent_path(current_user)
      end
    end
  end

  def dashboard
  end

  private
    def set_daycare
      @daycare = current_daycare
    end

    def set_parent
      @parent = current_daycare.parents.find(params[:id])
    end

    def parent_params
      params[:parent].delete('daycare_id')
      params.require(:parent).permit!
    end

end
