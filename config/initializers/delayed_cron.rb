DelayedCron.setup do |config|

  # default interval to run cron jobs
  config.default_interval = 10.minutes
  # array of methods to run at the above configured interval
  # config.cron_jobs = [
  #   # "SomeClass.expensive_task", # will run at default interval
  #   { job: "LoggerJob.new.async.perform('ssdfsdf')", interval: 40.seconds } # override default
  # ]

end