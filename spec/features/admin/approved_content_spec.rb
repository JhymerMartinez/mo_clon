require "rails_helper"

describe "approve contents" do
  let!(:current_user) { create :user, :admin }

  let!(:neuron) {
    create :neuron
  }

  let!(:content) {
    create :content, neuron: neuron,
                     kind: "que-es",
                     level: 1
  }

  before {
    login_as current_user
    visit admin_neuron_path(neuron)
  }

  feature "toggle `approved` flag", js: true do
    let(:click_btn!) {
      # select contents tab
      find("[href='#contents']").click

      # click approve toggle button
      btn = find "a#{btn_selector}"
      btn.click
    }

    describe "approve" do
      let(:btn_selector) { ".unapproved" }

      before {
        expect(neuron).to_not be_active
        click_btn!
      }

      it { expect(content.reload).to be_approved }
      it { expect(neuron.reload).to be_active }
    end

    describe "unapprove" do
      let(:btn_selector) { ".approved" }

      before {
        content.toggle! :approved
        neuron.update! active: true # HACK
        expect(neuron.reload).to be_active
        visit admin_neuron_path(neuron)
        click_btn!
      }

      it { expect(content.reload).to_not be_approved }
      it { expect(neuron.reload).to_not be_active }
    end
  end

end
