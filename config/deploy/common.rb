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
      RAILS_ENV=#{rails_env} rake gems:install
    CMD
  end
end

after 'deploy:update_code', 'gems:install'

namespace :god do
  task :stop_dj do
    sudo "god stop dj"
  end
  
  task :start_dj do
    sudo "god start dj"
  end
  
  task :reload do
    sudo "god load #{release_path}/config/god/app.god"
  end
end

before 'deploy:update_code', 'god:stop_dj'
after 'deploy:update_code', 'god:reload'
after 'deploy:update_code', 'god:start_dj'
