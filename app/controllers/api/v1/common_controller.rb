class Api::V1::CommonController < Api::V1::BaseController
	skip_before_action :authenticate_user_with_api_key

	def invite_daycare
		if params[:email] =~ /([^\s]+)@([^\s]+)/
			DaycareMailer.send_invite_to_daycare(params[:email]).deliver
	   	render json: {result: 'success', message: "Invitation to daycare has been sent successfully!"} and return
    else
      render json: {result: 'failed', error: true, message: "Invalid Email"} and return
	  end
	end
end