this_file = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
rails_root = File.expand_path(File.dirname(this_file) + '/../..')

God.watch do |w|
  w.name = "dj-1"
  w.group = 'dj'
  w.interval = 30.seconds
  
  env = ENV["RAILS_ENV"] || "production"
  
  w.log = "#{rails_root}/log/dj-1.log"
  
  w.pid_file = "#{rails_root}/tmp/pids/delayed_job.pid"
  # start = "su - hyewye -c 'RAILS_ENV=#{env} #{rails_root}/script/delayed_job start'"
  start = "su - hyewye -c 'cd #{rails_root} && RAILS_ENV=#{env} rake jobs:work'"
  puts start
  w.start = start
  
  # stop = "su - hyewye -c 'RAILS_ENV=#{env} #{rails_root}/script/delayed_job stop'"
  # puts stop
  # w.stop = stop
  # 
  # restart = "su - hyewye -c 'RAILS_ENV=#{env} #{rails_root}/script/delayed_job restart'"
  # puts restart
  # w.restart = restart
  
  w.behavior(:clean_pid_file)
  
  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = 75.megabytes
      c.times = [3, 5] # 3 out of 5 intervals
    end

    restart.condition(:cpu_usage) do |c|
      c.above = 50.percent
      c.times = 5
    end
  end

  # lifecycle
  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end

  # if env == "production"
  #   w.uid = 'hyewye'
  #   w.gid = 'hyewye'
  # end

  # restart if memory gets too high
  # w.transition(:up, :restart) do |on|
  #   on.condition(:memory_usage) do |c|
  #     c.above = 75.megabytes
  #     c.times = 2
  #   end
  # end
  # s
  # # determine the state on startup
  # w.transition(:init, { true => :up, false => :start }) do |on|
  #   on.condition(:process_running) do |c|
  #     c.running = true
  #   end
  # end
  # 
  # # determine when process has finished starting
  # w.transition([:start, :restart], :up) do |on|
  #   on.condition(:process_running) do |c|
  #     c.running = true
  #     c.interval = 5.seconds
  #   end
  # 
  #   # failsafe
  #   on.condition(:tries) do |c|
  #     c.times = 5
  #     c.transition = :start
  #     c.interval = 5.seconds
  #   end
  # end
  # 
  # # start if process is not running
  # w.transition(:up, :start) do |on|
  #   on.condition(:process_running) do |c|
  #     c.running = false
  #   end
  # end
end