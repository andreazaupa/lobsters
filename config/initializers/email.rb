# ActionMailer::Base.smtp_settings = {
#   :address => "127.0.0.1",
#   :port => 25,
#   :domain => Rails.application.domain,
#   :enable_starttls_auto => false,
# }

ActionMailer::Base.smtp_settings = {
  :user_name => 'azaupa',
  :password => "PASSWORD",
  :domain => 'develon.hack-inter.net',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
