class LoggerJob 
  include SuckerPunch::Job
  
  # cron_job :set_occurence, interval: 1.minute

  def perform(data)
    puts data
  end

  def later(sec, data)
    after(sec) { set_occurence }
  end

end
