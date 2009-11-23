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

namespace :gems do
  task :install, :roles => :app, :except => {:no_symlink => true} do
    run <<-CMD
      cd #{release_path} &&
      rake gems:install
    CMD
  end
end

after 'deploy:update_code', 'gems:install'