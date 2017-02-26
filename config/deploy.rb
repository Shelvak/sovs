# config valid only for current version of Capistrano
lock '3.7.2'

set :application, 'sovs'
set :repo_url, 'https://github.com/Shelvak/sovs.git'

set :deploy_to, '/var/rails/sovs'
set :deploy_via, :remote_cache

set :format, :pretty
set :log_level, ENV['log_level'] || :info

set :linked_files, %w(config/app_config.yml config/secrets.yml config/database.yml)
set :linked_dirs, %w(log private)
set :keep_releases, 2
