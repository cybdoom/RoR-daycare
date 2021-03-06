class DaycareMailer < ApplicationMailer

  def send_invite_to_workers(emails, daycare)
    emails = emails.join(",")
    @daycare = daycare
    mail(to: emails, subject: 'Welcome to Daycare')
  end

  def send_invite_to_parents(emails, daycare)
    emails = emails.join(",")
    @daycare = daycare
    mail(to: emails, subject: 'Welcome to Daycare')
  end

  def send_invite_to_daycare(email)
    @email = email
    mail(to: @email, subject: 'Welcome to Daycare')
  end

end
