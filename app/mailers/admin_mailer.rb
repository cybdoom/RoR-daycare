class AdminMailer < ActionMailer::Base
  default from: "noreply@healthychildcare.net"
  
  def forgot_password(admin)
      @admin = admin
      @url = "http://healthychildcare.net/password_reset?email=#{@admin.email}&token=#{@admin.password_digest[0..20]}"
      mail(to: @admin.email, subject: "Password reset link")
  end

  def invite_worker(email)
      @email = email
      mail(to: email, subject: "Worker invitation")
  end

  def invite_parent(email)
      mail(to: email, subject: "Parent invitation")
  end

end
