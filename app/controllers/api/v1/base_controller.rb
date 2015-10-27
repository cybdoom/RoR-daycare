class Api::V1::BaseController < ActionController::Base
  # protect_from_forgery with: :exception
  # rescue_from ActiveRecord::RecordNotFound, :with => :bad_record

  before_action :authenticate_user_with_api_key
  before_action :current_daycare
  # before_action :authenticate_with_api_key_and_role
  # before_action :require_user

    
  private

    # def current_user
    #   @current_user
    # end
    # helper_method :current_user

    def authenticate_user_with_api_key
      @current_user = nil
      authenticate_with_http_basic do |email, api_key|
        @current_user = User.find_by(email: email, api_key: api_key)
      end
      unless @current_user.present?
        render json: {error: true, message: 'Unauthorised'} and return
      end
    end


    # def authenticate_with_api_key_and_role
    #   @current_user = nil
    #   @current_user = params[:role].constantize.find_by_api_key(params[:api_key])
    #   unless @current_user.present?
    #     render json: {error: true, message: 'Unauthorised'} and return
    #   end
    # end
   
    def current_daycare
      if @current_user
        @current_daycare ||= @current_user.daycare
      else
        nil
      end
    end
    # helper_method :current_daycare

    # def require_user
    #   unless @current_user.present?
    #     render json: {error: true, message: 'Unauthorised'} and return
    #   end
    # end

    def require_device_token
      unless params[:device_token].present?
        render json: {result: 'failed', error: true, message: 'device token required'} and return
      end
    end

    def require_device_type
      unless params[:device_type].present?
        render json: {result: 'failed', error: true, message: 'device type required'} and return
      end
    end

    def set_device
      @device = Device.with_token_and_type(params[:device_token], params[:device_type])
      @device = Device.create(device_token: params[:device_token], device_type: params[:device_type]) unless @device.present?      
      render json: {result: 'failed', error: true, message: @device.errors.full_messages.uniq.join(', ')} and return if @device.errors.present?
    end

    def set_active_device
      if @user.present? && @user.valid?
        user_device = @device.user_devices.find_by(user_id: @user.id)
        user_device = UserDevice.create(user_id: @user.id, device_id: @device.id) unless user_device.present?
        user_device.activate_user_device
      end
    end
end