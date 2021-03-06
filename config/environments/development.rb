Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true


  

  #Raises error for missing translations
  #config.action_view.raise_on_missing_translations = true
  config.action_mailer.default_url_options = { host: "http://requesterapp.gionee.co.in" }

  # config.action_mailer.delivery_method = :smtp
  # config.action_mailer.smtp_settings = {
  #   address:              'smtp.sparkpostmail.com',
  #   port:                 587,
  #   user_name:            'SMTP_Injection',
  #   password:             '097d0f8478ba979cf679a15643d351811481c88b',
  #   authentication:       'plain',
  #   enable_starttls_auto: true  }

  # Rails.application.config.middleware.use ExceptionNotification::Rack,
  # :email => {
  #   :deliver_with => :deliver, # Rails >= 4.2.1 do not need this option since it defaults to :deliver_now
  #   :email_prefix => "Exception",
  #   :sender_address => %{"notifier" <notifier@gionee.co.in>},
  #   :exception_recipients => %w{raghav.singh@lptpl.com}
  # }  

end
