class UserMailer < ApplicationMailer
	default from: 'moi@example.com'

  def notify_role_change(user)
    @user = user
    mail(to: @user.email, subject: I18n.t("user_mailer.change_permission.subject"))
  end
end
