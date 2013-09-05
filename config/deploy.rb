
require "bundler/capistrano"
set :rvm_ruby_string, "1.9.3-p385"#"1.8.7-p371"
require "rvm/capistrano"
set :rvm_type, :system
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
server "neptune.azaupa.info", :web, :app, :db, :primary => true

set :application, "lobster"
set :user, "deploy"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git://github.com/andreazaupa/lobster.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
 namespace :db do
desc "[internal] Updates the symlink for database.yml file to the just deployed release."
  task :symlink, :except => { :no_release => true } do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end
  after "deploy:finalize_update", "db:symlink"
after "deploy", "deploy:cleanup" # keep only the last 5 releases



