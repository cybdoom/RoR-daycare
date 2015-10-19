class Api::V1::BaseController < ActionController::Base
  # protect_from_forgery with: :exception
  # rescue_from ActiveRecord::RecordNotFound, :with => :bad_record

  before_action :authenticate_user_with_api_key
  before_action :require_user

  private

    # def current_user
    #   @current_user
    # end
    # helper_method :current_user

    # def authenticate_user_with_api_key
    #   @current_user = nil
    #   authenticate_with_http_basic do |email, api_key|
    #     @current_user = User.with_email_and_api_key(email, api_key)
    #     unless @current_user.present?
    #       render json: {error: true, message: 'Unauthorised'} and return
    #     end
    #   end
    # end

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
      if @user.present?
        user_device = @device.user_devices.find_by(user_id: @user.id)
        user_device = UserDevice.create(user_id: @user.id, device_id: @device.id) unless user_device.present?
        user_device.activate_user_device
      end
    end
end