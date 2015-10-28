class CommonController < ApplicationController

  def confirm_account
    if params[:user_type].present? && params[:token].present?
      user = User.find_by(confirmation_token: params[:token])
      if user
        user.update(confirmation_token: nil, confirmation_sent_at: nil, confirmed_at: DateTime.now)
        flash[:success] = 'Your account has been successfully confirmed. You can now login!'
        case params[:user_type]
        when 'Worker'
          redirect_to login_daycare_workers_path
        when 'Manager'
          redirect_to login_daycares_path
        when 'Parent'
          redirect_to login_daycare_parents_path
        end
      else
        flash[:error] = 'The confirmation link seems to be expired!'
        redirect_to root_url
      end
    else
      flash[:error] = 'The confirmation link seems to be invalid!'
      redirect_to root_url
    end
  end

  def invite_daycare
    DaycareMailer.send_invite_to_daycare(params[:email_id]).deliver_later
    flash[:success] = 'Invitation to daycare has been sent successfully!'
    redirect_to root_url
  end

end
