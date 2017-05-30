ruby "2.1.4"

source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.2'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

gem 'time_diff', '~> 0.3.0'

gem 'websocket-rails'

gem 'faye-websocket', '0.10.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem "jquery-ui-rails"

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'dotenv-rails', require: 'dotenv/rails-now'

gem 'slim'
gem 'devise'
gem 'devise_token_auth', github: "lynndylanhurley/devise_token_auth"
gem 'decent_exposure'
gem 'kaminari'
gem 'lograge'
gem 'breadcrumbs_on_rails'
gem 'cancan'
gem 'jquery-datatables-rails', github: 'rweng/jquery-datatables-rails'
gem 'active_model_serializers'
gem 'paper_trail', '~> 4.0.0.beta'
gem 'little_decorator', github: 'macool/little_decorator'
gem 'nested_form'
gem 'acts-as-taggable-on'
gem 'google-api-client'
gem 'searchlight'
gem 'spellchecker', github: 'nicholasjhenry/spellchecker'
gem 'carrierwave'
gem 'carrierwave-base64'
gem 'rubocop', require: false
gem "rack-cors", require: "rack/cors"
gem "newrelic_rpm"
gem 'airbrake'
gem 'foreman'

gem 'delayed_job_active_record'
gem 'delayed_job_web'
gem 'daemons' # to manage background processing (delayed_job)

group :doc do
  gem 'yard'
end

group :api do
  gem 'maruku'
  gem 'apipie-rails'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'pry-rails'
  gem 'poltergeist', '~> 1.6'
  gem 'database_cleaner', '~> 1.3.0'
  gem 'connection_pool'
  gem 'rspec_junit_formatter'
end

group :development do
  gem 'mailcatcher'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'rack-mini-profiler'
  gem 'annotate'
  gem 'bullet'
  # gem 'neography', github: "maxdemarzi/neography", require: false
end

group :deployment do
  gem 'capistrano', '~> 3.4'
  gem 'capistrano-rails'
  gem 'capistrano-passenger'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'slackistrano', require: false

  gem 'capistrano3-delayed-job'
end

group :staging, :integration do
  gem 'rails_12factor'
  gem 'cloudinary'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use puma as the app server
gem 'puma'
