source 'https://rubygems.org'

gem 'rails', '~> 5.0'

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'simple_form'
gem 'devise'
gem 'cancan'
gem 'role_model'
gem 'paper_trail'
gem 'validates_timeliness'
gem 'sidekiq'

# gem 'prawn'
# gem 'cups'
# gem 'newrelic_rpm'

gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'awesome_print'
gem 'bootstrap-kaminari-views'
gem 'puma'
gem 'sqlite3'
gem 'byebug'

gem 'bugsnag'

unless ENV['SKIP_POSTGRES']
  gem 'pg'
end

group :development do
  gem 'thin'
  #gem 'virb'
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano3-puma'
end

group :test do
  gem 'turn', require: false
  gem 'selenium-webdriver'
  gem 'capybara', require: false
  gem 'database_cleaner' # For Capybara
  gem 'fabrication'
  gem 'faker'
  gem 'rails-controller-testing'
end
