class Api::V1::RegistrationsController < Api::V1::BaseController
  skip_before_action :authenticate_user_with_api_key
  skip_before_action :require_user

  before_action :require_device_token, only: [:create]
  before_action :require_device_type, only: [:create]
  before_action :set_device, only: [:create]
  after_action :set_active_device, only: [:create]
  
  def create
    role = params[:daycare][:manager_attributes][:role] if params[:daycare] && params[:daycare][:manager_attributes]
    role ||= params[:user][:role] if params[:user] && params[:user][:role] 
    if role == "superadmin"
      create_super_admin
    elsif role == "manager"
      create_daycare_and_daycare_manager
    elsif role == "parent"
      creaate_daycare_parent
    elsif role == "worker"
      create_daycare_worker
    else
      @message = "Invalid Role Provided"
    end

    if @user && @message
      render json: {result: 'success', message: @message, api_key: @user.api_key} and return
    else
      render json: {result: 'failed', error: true, message: @message} and return
    end
  end

  private

    
    def create_super_admin
      @message = "In Progress"
    end

    def create_daycare_and_daycare_manager
      @daycare = Daycare.new(daycare_params)
      country = ISO3166::Country.new(params[:daycare][:country])
      @daycare.country = country.name
      if @daycare.save
        @user = @daycare.manager
        @message = "Daycare and its manager created Successfully"
      else
        @message = @daycare.errors.full_messages.uniq.join(', ')
      end
    end

    def create_daycare_worker
      @message = "In Progress"
    end

    def creaate_daycare_parent
      @message = "In Progress"
    end

    def daycare_params
      params.require(:daycare).permit(:name, :address_line1, :post_code, :country, :telephone, :customer_type_id, :language, manager_attributes: [:name, :email, :password, :password_confirmation])
    end

    
end