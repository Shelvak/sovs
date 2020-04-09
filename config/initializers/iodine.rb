if defined?(Iodine)
  production = ENV.fetch('RAILS_ENV', 'development') == 'production'

  Iodine.run_every(12 * 60 * 60 * 1000) do
    Process.kill('SIGUSR1', Process.pid) unless Iodine.worker?
  end

  Iodine.workers = 1 # ENV.fetch('WEB_CONCURRENCY', production ? 3 : 1).to_i
  Iodine.threads = ENV.fetch('RAILS_MAX_THREADS', 5).to_i

  Iodine::DEFAULT_SETTINGS[:port] = ENV.fetch('PORT', 3000)
end
