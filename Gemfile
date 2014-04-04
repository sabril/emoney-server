source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.3'

gem 'pg'
gem "mongoid", :github => "mongoid/mongoid"
gem "bson_ext"
## authentication and authorization
gem "devise"
gem "cancan"
gem 'simple_token_authentication'

# Use SCSS for stylesheets
gem "less-rails"
gem "therubyracer"
gem 'sass-rails', '~> 4.0.0'
gem "kaminari"
gem 'kaminari-bootstrap', '~> 3.0.1'
gem 'twitter-bootstrap-rails', github: "seyhunak/twitter-bootstrap-rails", branch: "bootstrap3"
gem 'sprockets-rails', :require => 'sprockets/railtie'

gem 'quiet_assets', :group => :development
gem "simple_form"

# track
gem 'paper_trail', '~> 3.0.0'
gem 'inherited_resources'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
#gem 'grape', github: 'intridea/grape'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'unicorn'

group :development, :test do
  gem "rspec-rails", "2.13.0"
  gem "guard-rspec"
  gem "guard-bundler"
  gem "rb-fsevent"
  gem 'simplecov', :require => false
  gem "faker"
  gem "database_cleaner"
end

group :test do
  gem "capybara"
  gem "factory_girl_rails", "4.1.0"
  gem "forgery"
  gem "zeus"
  gem 'selenium-webdriver'
  gem "launchy"
end

gem 'jquery-ui-rails'

group :assets do
  gem 'turbo-sprockets-rails3'
end
# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
group :development do
  gem 'thin'
  gem "rails_best_practices"
end

gem "brakeman"
gem "figaro"
gem "wicked"
gem 'rubysl-securerandom'
gem 'mongoid-embedded-errors'
gem "exception_notification", :git => "git://github.com/rails/exception_notification.git", :require => "exception_notifier"