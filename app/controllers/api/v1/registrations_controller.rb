class Api::V1::RegistrationsController < Api::V1::BaseController
  skip_before_action :authenticate_user_with_api_key
  # skip_before_action :require_user

  before_action :require_device_token, only: [:create]
  before_action :require_device_type, only: [:create]
  before_action :set_device, only: [:create]
  # after_action :set_active_device, only: [:create]

  def create
    begin
      role = params[:daycare][:manager_attributes][:role] if params[:daycare] && params[:daycare][:manager_attributes]
      role ||= params[:user][:role] if params[:user] && params[:user][:role]
      if role == "superadmin"
        create_super_admin
      elsif role == "manager"
        create_daycare_and_daycare_manager
      elsif role == "parent"
        create_daycare_parent
      elsif role == "worker"
        create_daycare_worker
      else
        @message = "Invalid Role Provided"
      end
    rescue ActiveRecord::InvalidForeignKey => error
      @message = "Provided Invalid daycare_id or department_id "
    rescue Exception => e
      @message = e.message
    ensure
      if @user && @user.valid?
        set_active_device
        render json: {result: 'success', message: @message, api_key: @user.api_key} and return
      else
        render json: {result: 'failed', error: true, message: @message} and return
      end
    end
  end

  private

    def create_super_admin
      @message = "Cannot create admin. No Such API"
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
      # "worker"=>{"daycare_id"=>"1", "department_id"=>"2", "username"=>"ashu", "email"=>"ashu@gmail.com", "password"=>"11111111"}
      # @daycare = Daycare.find(params[:user][:daycare_id])
      # @message = "Invalid daycare_id" and return unless @daycare.present?

      # @department = @daycare.departments.find(params[:user][:department_id])
      # @message = "Invalid department_id" and return unless @department.present?
      # @user = @daycare.workers.new(worker_params)
      
        @user = Worker.new(worker_params)
        if @user.save
          @message = "Worker created Successfully"
        else
          @message = @user.errors.full_messages.uniq.join(', ')
        end

    end

    def create_daycare_parent
      @user = Parent.new(parent_params)
      if @user.save
        @message = "Parent created Successfully"
      else
        @message = @user.errors.full_messages.uniq.join(', ')
      end
    end

    def daycare_params
      params.require(:daycare).permit(:name, :address_line1, :post_code, :country, :telephone, :customer_type_id, :language, manager_attributes: [:name, :email, :password, :password_confirmation])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def worker_params
      params[:user][:password_confirmation] = params[:user][:password]
      params.require(:user).permit(:daycare_id, :department_id, :name, :email, :password, :password_confirmation)
    end

    def parent_params
      params[:user][:password_confirmation] = params[:user][:password]
      # params.require(:user).permit(:daycare_id, :name, :email, :password, :password_confirmation)
      params[:user].delete("role")
      params.require(:user).permit!
    end

    def clid_params
      params.require(:user).permit({:children_attributes => [:name, :birth_year, :department_id, :photo_attributes]})
    end


end