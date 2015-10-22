class RegistrationMailer < ApplicationMailer

	def send_confirmation(user)
		@user = user
		@user.update(confirmation_token: SecureRandom.hex, confirmation_sent_at: DateTime.now)
		mail(to: @user.email, subject: 'Confirm Your Account')
	end

end
