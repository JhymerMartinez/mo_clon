user = Rails.application.secrets.delayed_job_user
passwd = Rails.application.secrets.delayed_job_password

if Rails.env.production? || (user.present? && passwd.present?)
  DelayedJobWeb.use Rack::Auth::Basic do |auth_user, auth_passwd|
    auth_user == user && auth_passwd == (passwd || SecureRandom.hex)
  end
end
