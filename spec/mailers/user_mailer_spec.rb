require "rails_helper"

RSpec.describe UserMailer, :type => :mailer do
	let(:user) { build :user }
	let(:mail) { UserMailer.notify_role_change(user) }

	it 'send email whit subject' do
		expect(mail.subject).to eql(I18n.t("user_mailer.change_permission.subject"))
	end

  it 'renders the receiver email' do
    expect(mail.to).to eql([user.email])
  end

	it 'renders the sender email' do
    expect(mail.from).to eql(['moi@example.com'])
  end

	it 'have new role' do
		expect(mail.body.encoded).to have_text(user.role)
	end
end
