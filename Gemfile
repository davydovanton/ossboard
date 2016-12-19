source 'https://rubygems.org'

ruby '2.3.0'

gem 'bundler'
gem 'rake'
gem 'hanami',       '~> 0.9'
gem 'hanami-model', '~> 0.7'

# markdown
gem 'kramdown'
gem 'rouge'

gem 'pg'
gem 'travis'

gem 'omniauth'
gem 'omniauth-github', github: 'intridea/omniauth-github'

gem 'slim'
gem 'hanami-webpack', github: 'samuelsimoes/hanami-webpack'
gem 'sass'

gem 'dry-matcher'

group :development do
  # Code reloading
  # See: http://hanamirb.org/guides/projects/code-reloading
  gem 'shotgun'

  # gem 'hanami-scaffold', github: 'davydovanton/hanami-scaffold'
end

group :test, :development do
  gem 'dotenv', '~> 2.0'
end

group :test do
  gem 'rspec'
  gem 'rspec-hanami', github: 'davydovanton/rspec-hanami'
  gem 'capybara'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
end

group :production do
  # gem 'puma'
end
