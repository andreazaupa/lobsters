
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
set :repository, "git@github.com:andreazaupa/lobsters.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
 namespace :db do
desc "[internal] Updates the symlink for database.yml file to the just deployed release."
  task :symlink, :except => { :no_release => true } do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/sphynx.yml #{release_path}/config/sphynx.yml"
    run "cp #{shared_path}/config/initializers/email_conf.rb #{release_path}/config/initializers/email_conf.rb"
  end
end
  after "deploy:finalize_update", "db:symlink"
after "deploy", "deploy:cleanup" # keep only the last 5 releases



set :whenever_command, "bundle exec whenever"
set :whenever_environment, "production"
set :whenever_identifier, defer { "#{application}" }

require "whenever/capistrano"

after "deploy:update_code", "whenever:clear_crontab"
# Write the new cron jobs near the end.
after "deploy:create_symlink", "whenever:update_crontab"
# If anything goes wrong, undo.
after "deploy:rollback", "whenever:update_crontab"