source 'https://rubygems.org'

ruby '2.3.0'

gem 'bundler'
gem 'rake'
gem 'hanami',       '~> 0.9'
gem 'hanami-model', '~> 0.7'
gem 'puma'

# markdown
gem 'kramdown', '1.13.1'
gem 'rouge', '1.11.1'

gem 'pg'
gem 'redis', '~>3.2'
gem 'hiredis'
gem 'mock_redis'
gem 'connection_pool'

gem 'omniauth'
gem 'omniauth-github', github: 'intridea/omniauth-github'

gem 'slim'
gem 'hanami-webpack', github: 'samuelsimoes/hanami-webpack'
gem 'sass'
gem 'relative_time'

gem 'dry-matcher'

gem 'sidekiq'

gem 'newrelic-hanami', github: 'artemeff/newrelic-hanami'
gem 'secure_headers'

gem 'twitter'

group :development do
  # Code reloading
  # See: http://hanamirb.org/guides/projects/code-reloading
  gem 'shotgun'

  # gem 'hanami-scaffold', github: 'davydovanton/hanami-scaffold'

  gem 'rack-mini-profiler', require: false
  gem 'memory_profiler'
end

group :test, :development do
  gem 'dotenv', '~> 2.0'

  gem 'danger'
  gem 'danger-rubocop'
  gem 'danger-simplecov_json'
end

group :test do
  gem 'rspec'
  gem 'rspec-hanami', github: 'davydovanton/rspec-hanami'
  gem 'capybara'
  gem 'simplecov', require: false
  gem 'simplecov-json', require: false
  gem 'vcr'
  gem 'webmock'
  gem 'hanami-fabrication'
  gem 'faker'
  gem 'timecop'
end

group :production do
  # gem 'puma'
end
