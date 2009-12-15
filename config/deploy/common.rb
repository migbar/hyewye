set :application, "hyewye"

set :scm, :git
set :repository, "git@github.com:migbar/hyewye.git"
set :deploy_via, :remote_cache

namespace :deploy do
  task(:start) {}
  task(:stop) {}
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  task :copy_database_config, :roles => :app, :except => {:no_symlink => true} do
    run <<-CMD
      cd #{release_path} &&
      cp #{shared_path}/config/database.yml #{release_path}/config/database.yml
    CMD
  end
end

after 'deploy:update_code', 'deploy:copy_database_config'

namespace :gems do
  task :install, :roles => :app, :except => {:no_symlink => true} do
    run <<-CMD
      cd #{release_path} &&
      sudo rake gems:install RAILS_ENV=#{rails_env}
    CMD
  end
end

after 'deploy:update_code', 'gems:install'

namespace :monit do
  task :stop_dj do
    sudo "monit stop delayed_job"
  end
  
  task :start_dj do
    sudo "monit start delayed_job"
  end
end

before 'deploy:update_code', 'monit:stop_dj'
after 'deploy:update_code', 'monit:start_dj'
