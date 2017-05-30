RSpec.shared_examples "requests:current_user" do
  let(:current_user) { create :user }
  before { login_as current_user }
end
