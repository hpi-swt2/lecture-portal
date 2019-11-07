# lecture-portal

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

Web application for organizing and managing lecture participation, written in [Ruby on Rails](https://rubyonrails.org/).
Created in the [Software Engineering II course](https://hpi.de/plattner/teaching/winter-term-201920/softwaretechnik-ii.html) at HPI in Potsdam.

## Setup

* Ensure [Ruby](https://www.ruby-lang.org/) v2.5.1 (`ruby -v`) with [rbenv](https://github.com/rbenv/rbenv) or [RVM](http://rvm.io/)
* Ensure [Bundler](https://rubygems.org/gems/bundler) v2.0.2 (`bundle -v`) with `gem install bundler -v 2.0.2`
* `bundle install --without production` Install the required Ruby gem dependencies defined in the Gemfile, skipping gems used for production (like [pg](https://rubygems.org/gems/pg/))
* `rails db:migrate db:seed` Setup database, run migrations, seed the database with defaults
* `rails s` Start the Rails development server (By default runs on _localhost:3000_)
* `bundle exec rspec` Run all the tests (using the [RSpec](http://rspec.info/) test framework)

## Developer Guide

### Setup
* `bundle exec rails db:migrate RAILS_ENV=development && bundle exec rails db:migrate RAILS_ENV=test` Migrate both test and development databases
* `bundle exec rails assets:clobber && bundle exec rails assets:precompile` Redo asset generation

### Testing
* To run the full test suite: `bundle exec rspec`.
* For fancier test running use option `-f doc` 
* `bundle exec rspec spec/<rest_of_file_path>.rb` Specify a folder or test file to run
* specify what tests to run dynamically by `-e 'search keyword in test name'`
* `bundle exec rspec --profile` examine how much time individual tests take

### Linting
* [RuboCop](https://github.com/rubocop-hq) is a Ruby static code analyzer and formatter, based on the community [Ruby style guide](https://github.com/rubocop-hq/ruby-style-guide)
* It is installed in the project. Run `bundle exec rubocop` to find possible issues.
* Use `--auto-correct` to fix what can be fixed automatically.
* The behavior of RuboCop can be [controlled](https://docs.rubocop.org/en/latest/configuration/) via a `.rubocop.yml` configuration file

### Debugging
* `rails c --sandbox` Test out some code in the Rails console without changing any data
 `rails dbconsole` Starts the CLI of the database you're using
* `bundle exec rails routes` Show all the routes (and their names) of the application
* `bundle exec rails about` Show stats on current Rails installation, including version numbers

### Generating
* `rails g migration DoSomething` Create migration _db/migrate/*_DoSomething.rb_.