# config valid only for current version of Capistrano
lock '3.7.2'

set :application, 'sovs'
set :repo_url, 'https://github.com/Shelvak/sovs.git'

set :deploy_to, '/var/rails/sovs'
set :deploy_via, :remote_cache

set :format, :pretty
set :log_level, ENV['log_level'] || :info

set :linked_files, %w(config/app_config.yml config/secrets.yml config/database.yml config/puma.rb )
set :linked_dirs, %w(log private)
set :keep_releases, 2

task :restart_server do
  on roles(:web) do
    execute :touch, release_path.join('tmp/restart.txt')
  end
end
after "deploy:published", "restart_server"


# Clear existing task so we can replace it rather than "add" to it.
Rake::Task["deploy:compile_assets"].clear

namespace :deploy do

  desc 'Compile assets'
  task :compile_assets => [:set_rails_env] do
    # invoke 'deploy:assets:precompile'
    invoke 'deploy:assets:precompile_local'
    invoke 'deploy:assets:backup_manifest'
  end


  namespace :assets do
    desc "Precompile assets locally and then rsync to web servers"
    task :precompile_local do
      # compile assets locally
      run_locally do
        execute "RAILS_ENV=#{fetch(:stage)} bundle exec rake assets:precompile"
      end

      # rsync to each server
      local_dir = "./public/assets/"
      on roles( fetch(:assets_roles, [:web]) ) do
        # this needs to be done outside run_locally in order for host to exist
        remote_dir = "#{host.user}@#{host.hostname}:#{release_path}/public/assets/"

        run_locally { execute "rsync -av --delete #{local_dir} #{remote_dir}" }
      end

      # clean up
      run_locally { execute "rm -rf #{local_dir}" }
    end
  end
end
