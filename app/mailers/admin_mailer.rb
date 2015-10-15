class AdminMailer < ApplicationMailer

  def notify_workers(daycare)
    @daycare = daycare
    workers = @daycare.workers
    emails = workers.map(&:email).join(",")
    mail(to: emails, subject: 'Welcome to Daycare as a worker')
  end

  def notify_parents(daycare)
    @daycare = daycare
    parents = @daycare.parents
    emails = parents.map(&:email).join(",")
    mail(to: emails, subject: 'Welcome to Daycare as a parent')
  end

  def notify_manager(daycare)
    @daycare = daycare
    mail(to: @daycare.manager.email, subject: 'Welcome to Daycare as a manager')
  end
  
end
