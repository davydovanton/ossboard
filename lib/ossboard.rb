Hanami::Utils.require!("#{__dir__}/ossboard")

Hanami::Mailer.configure do
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
end.load!
