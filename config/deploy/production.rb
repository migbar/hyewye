load "config/deploy/common"

role :web, "hyewye.com"                          # Your HTTP server, Apache/etc
role :app, "hyewye.com"                          # This may be the same as your `Web` server
role :db,  "hyewye.com", :primary => true        # This is where Rails migrations will run

default_run_options[:pty] = true
# ssh_options[:forward_agent] = true
set :use_sudo, false
set :user, "hyewye"
set :branch, "stable"
set :deploy_to, "/home/hyewye/app"
set :rails_env, "production"
