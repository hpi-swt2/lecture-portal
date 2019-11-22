# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.5.1"

#
# Rails essentials
#

# The application framework. https://github.com/rails/rails
gem "rails", "~> 5.2.3"
# Use sqlite3 as the database for Active Record. https://www.sqlite.org/index.html
gem "sqlite3"
# Use Puma as the app server. https://github.com/puma/puma
gem "puma", "~> 3.11"
# Use Uglifier as compressor for JavaScript assets. https://github.com/lautis/uglifier
gem "uglifier", ">= 1.3.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
gem "mini_racer", platforms: :ruby
# Turbolinks makes navigating your web application faster. https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

#
# Additional core gems
#

# Linter / Formatter using Rubocop https://github.com/rubocop-hq/rubocop
gem "rubocop", require: false
# Rails Extension for Rubocop https://github.com/rubocop-hq/rubocop-rails
gem "rubocop-rails", require: false
# rspec Extension for Rubocop https://github.com/rubocop-hq/rubocop-rspec
gem "rubocop-rspec", require: false
# Extension for Rubocop https://github.com/rubocop-hq/rubocop-performance
gem "rubocop-performance", require: false

# Flexible authentication solution for Rails with Warden
gem "devise" # https://github.com/plataformatec/devise
gem "devise-i18n" # https://github.com/tigrish/devise-i18n
gem "devise-bootstrap-views", "~> 1.0" # https://github.com/hisea/devise-bootstrap-views
# Provides different authentication strategies
# gem 'omniauth' # https://github.com/omniauth/omniauth
# gem 'omniauth_openid_connect' # https://github.com/m0n9oose/omniauth_openid_connect
# Build JSON APIs with ease. https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Role management, minimal authorization through OO design and pure Ruby classes
# gem 'pundit' # https://github.com/varvet/pundit
# Web service for tracking code coverage over time
# https://coveralls.io/github/hpi-swt2/lecture-portal
# gem 'coveralls', require: false
# Report errors in production to central Errbit system
# https://github.com/errbit/errbit
# gem 'airbrake', '~> 5.0' # https://github.com/airbrake/airbrake

#
# Packaged JS, CSS libraries and helpers
#

# Fancy default views and javascript helpers
gem "bootstrap", "~> 4.3.1" # https://github.com/twbs/bootstrap-rubygem
# jQuery for Rails
gem "jquery-rails" # https://github.com/rails/jquery-rails
# The font-awesome font bundled as an asset for the Rails asset pipeline
gem "font-awesome-rails" # https://github.com/bokmann/font-awesome-rails
# jQuery datatables Ruby gem for assets pipeline, https://datatables.net/
# gem 'jquery-datatables' # https://github.com/mkhairi/jquery-datatables
# Integrate Select2 javascript library with Rails asset pipeline
# gem 'select2-rails' # https://github.com/argerim/select2-rails
# Packaged clipboard.js JS library for copying text to clipboard
# gem 'clipboard-rails' # https://github.com/sadiqmmm/clipboard-rails
# Rails form builder for creating forms using Bootstrap 4
# gem "bootstrap_form", ">= 4.2.0" # https://github.com/bootstrap-ruby/bootstrap_form

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console. https://github.com/deivid-rodriguez/byebug
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  # RSpec testing framework as a drop-in alternative to Rails' default testing framework, Minitest
  gem "rspec-rails", "~> 3.8" # https://github.com/rspec/rspec-rails
  # State of the art fixtures
  gem "factory_bot_rails" # https://github.com/thoughtbot/factory_bot_rails
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 3.3.0" # https://github.com/rails/web-console
  # The Listen gem listens to file modifications and notifies you about the changes.
  gem "listen", ">= 3.0.5", "< 3.2" # https://github.com/guard/listen
  # Spring speeds up development by keeping your application running in the background
  gem "spring" # https://github.com/rails/spring
  # Makes Spring watch the filesystem for changes using Listen rather than by polling the filesystem
  gem "spring-watcher-listen", "~> 2.0.0" # https://github.com/jonleighton/spring-watcher-listen
  # gem 'rubocop', require: false # https://github.com/rubocop-hq/rubocop
  # Code style checking for RSpec files
  # gem 'rubocop-rspec' # https://github.com/rubocop-hq/rubocop-rspec
  # Replaces standard Rails error page with a more useful error page
  # binding_of_caller is optional, but is necessary to use Better Errors' advanced features
  # gem 'better_errors' # https://github.com/BetterErrors/better_errors
  # gem 'binding_of_caller'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"
  # gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  # gem 'chromedriver-helper'
  # Port of Perl's Data::Faker library that generates fake data
  # gem 'faker' # https://github.com/stympy/faker
  # Code coverage for Ruby
  # gem 'simplecov', require: false # https://github.com/colszowka/simplecov
end

group :production do
  gem "pg" # production database runs on postgres
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'webpacker'
gem 'react-rails'

gem 'rack-cors'