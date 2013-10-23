require 'bundler/capistrano'
default_run_options[:shell] = false

set :application, 'sovs'
set :repository,  'https://github.com/losmostros/sovs.git'
set :deploy_to, '/var/rails/sovs'
set :deploy_via, :remote_cache
set :user, 'deployer'
set :group_writable, false
set :shared_children, %w(log)
set :use_sudo, false

set :scm, :git
set :branch, 'master'

role :web, 'torrent-fiambre.no-ip.org'
role :app, 'torrent-fiambre.no-ip.org'
role :db, 'torrent-fiambre.no-ip.org', primary: true

before 'deploy:finalize_update', 'deploy:create_shared_symlinks'

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  
  task :restart, roles: :app, except: { no_release: true } do
    run "touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end

  desc 'Creates the symlinks for the shared folders'
  task :create_shared_symlinks, roles: :app, except: { no_release: true } do
    shared_paths = [
      ['private'], ['config', 'app_config.yml'], ['print_escaped_strings']
    ]

    shared_paths.each do |path|
      shared_files_path = File.join(shared_path, *path)
      release_files_path = File.join(release_path, *path)

      run "ln -s #{shared_files_path} #{release_files_path}"
    end
  end
end
