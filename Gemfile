source 'https://rubygems.org'

ruby '2.4.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rake'
gem 'hanami',       '1.1.0'
gem 'hanami-model', '1.1.0'
gem 'puma'
gem 'letsencrypt_rack'
gem 'letsencrypt_heroku', require: false

# markdown
gem 'kramdown', '1.13.1'
gem 'rouge', '1.11.1'
gem 'rinku'

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
gem 'hanami-pagination', github: 'davydovanton/hanami-pagination'

gem 'hanami-serializer', github: 'davydovanton/hanami-serializer'

gem 'dry-matcher'
gem 'dry-monads'
gem 'dry-system'

gem 'sidekiq'
gem 'sidekiq-scheduler'

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
  gem 'database_cleaner'
  gem 'pry'
  gem 'pry-byebug'
end

group :test do
  gem 'rspec'
  gem 'rspec-hanami', github: 'davydovanton/rspec-hanami'
  gem 'capybara'
  gem 'poltergeist'
  gem 'simplecov', require: false
  gem 'simplecov-json', require: false
  gem 'vcr'
  gem 'webmock'
  gem 'hanami-fabrication'
  gem 'faker'
  gem 'timecop'
  gem 'rspec-retry'
end

group :production do
  gem 'newrelic-hanami', github: 'artemeff/newrelic-hanami'
end
