class DaycareParentsController < ApplicationController
  before_action :authenticate_parent!, except: [:login, :create, :choose_daycare, :register]
  before_action :ensure_parent, except: [:login, :create, :choose_daycare, :register]
  before_action :set_daycare, only: [:dashboard]
  before_action :set_parent, only: [:dashboard]

  def register
    @daycare = Daycare.find(params[:daycare_id])
    @departments = @daycare.departments
    @parent = @daycare.parents.new
    @parent.children.new
    render :register
  end

  def create
    if params[:department_ids].present?
      params[:parent][:children_attributes].each_with_index do |(key, value), index|
        value['department_id'] = params[:department_ids][index]
      end
    end
    @parent = Parent.new(parent_params)
    if @parent.save!
      flash[:success] = "Parent Successfully created."
      RegistrationMailer.send_confirmation(@parent).deliver_later
      redirect_to dashboard_daycare_parent_path(@parent)
    else
      render :new
    end
  end

  def login
    if request.post?
      @user = User.find_by(email: params[:email])
      if @user.confirmation_token.present?
        flash[:error] = "You haven't confirm your account yet. Please confirm your account to login!"
        redirect_to root_path
      else
        path = login_user_and_set_redirect_path("parent")
        redirect_to path
      end
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
      params.require(:parent).permit!
    end

end
