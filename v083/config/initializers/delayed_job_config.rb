# config/initializers/delayed_job_config.rb
Delayed::Worker.destroy_failed_jobs = true
Delayed::Worker.sleep_delay = 0
Delayed::Worker.max_attempts = 0
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.read_ahead = 10
## Delayed::Worker.delay_jobs = !Rails.env.test?
