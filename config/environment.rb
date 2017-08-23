require 'bundler/setup'
require 'hanami/setup'
require 'hanami/model'
require 'sidekiq/web'
require_relative '../system/import'
require_relative '../lib/ossboard'
require_relative '../apps/api/application'
require_relative '../apps/auth/application'
require_relative '../apps/admin/application'
require_relative '../apps/web/application'

Hanami.configure do
  mount Api::Application, at: '/api'
  mount Auth::Application, at: '/auth'
  mount Admin::Application, at: '/admin'
  mount Web::Application, at: '/'

  model do
    ##
    # Database adapter
    #
    # Available options:
    #
    #  * SQL adapter
    #    adapter :sql, 'sqlite://db/ossboard_development.sqlite3'
    #    adapter :sql, 'postgres://localhost/ossboard_development'
    #    adapter :sql, 'mysql://localhost/ossboard_development'
    #
    adapter :sql, ENV['DATABASE_URL']

    ##
    # Migrations
    #
    migrations 'db/migrations'
    schema     'db/schema.sql'

    logger "log/#{Hanami.env}.log", level: :debug
  end

  mailer do
    root Hanami.root.join("lib", "ossboard", "mailers")

    # See http://hanamirb.org/guides/mailers/delivery
    delivery :test
  end

  # These two blocks are new.
  # They MUST be after the general settings like `mount`, `model`, `mailer`.
  environment :development do
    # See: http://hanamirb.org/guides/projects/logging
    logger level: :info
  end

  environment :production do
    logger level: :info, formatter: :json

    mailer do
      delivery  :smtp,
        port:      587,
        address:   "smtp.mailgun.org",
        user_name: ENV['MAILGUN_USERNAME'],
        password:  ENV['MAILGUN_PASSWORD'],
        authentication: 'plain',
        enable_starttls_auto: true
    end
  end

end
