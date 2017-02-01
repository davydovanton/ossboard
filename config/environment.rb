require 'bundler/setup'
require 'hanami/setup'
require 'hanami/model'
require 'sidekiq/web'
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
  end

  mailer do
    root 'lib/ossboard/mailers'

    # See http://hanamirb.org/guides/mailers/delivery
    delivery do
      development :test
      test        :test
      production  :smtp,
        port:      587,
        address:   "smtp.mailgun.org",
        user_name: ENV['MAILGUN_USERNAME'],
        password:  ENV['MAILGUN_PASSWORD'],
        authentication: 'plain',
        enable_starttls_auto: true
    end
  end
end
