this_file = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
rails_root = File.expand_path(File.dirname(this_file) + '/../..')

God.watch do |w|
  w.name = "dj-1"
  w.group = 'dj'
  w.interval = 30.seconds
  
  env = ENV["RAILS_ENV"] || "production"
  
  w.pid_file = "#{rails_root}/tmp/pids/delayed_job.pid"
  start = "su - hyewye -c 'RAILS_ENV=#{env} #{rails_root}/script/delayed_job start'"
  puts start
  w.start = start
  
  stop = "su - hyewye -c 'RAILS_ENV=#{env} #{rails_root}/script/delayed_job stop'"
  puts stop
  w.stop = stop

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