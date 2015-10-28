class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :authenticate_user_with_api_key
  # skip_before_action :require_user

  before_action :require_device_token, only: [:create]
  before_action :require_device_type, only: [:create]
  before_action :set_device, only: [:create]
  # after_action :set_active_device, only: [:create]

  def create
    @user, @error_msg = User.authentication_user_with_login_parameters(params[:login], params[:password], params[:role])
    if @error_msg.present?
      render json: {result: 'failed', error: true, message: @error_msg} and return
    else
      set_active_device
      render json: {result: 'success', message: 'Authentication successful', api_key: @user.api_key, name: @user.name} and return
    end
  end
end