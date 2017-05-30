RSpec.shared_context "form features" do
  let(:submit_form!) {
    find("input[type='submit']").click
  }
end

RSpec.shared_context "neuron form features" do
  let(:neuron_attrs) { attributes_for :neuron }

  let(:first_textarea) {
    all("textarea[name*='description']").first
  }

  let(:source_input) {
    find "[name$='[source]']"
  }

  let(:select_contents_tab!) {
    # select `contents` tab:
    click_on I18n.t("activerecord.models.content").pluralize
  }

  let(:fill_form!) {
    neuron_attrs.each do |key, value|
      label = I18n.t("activerecord.attributes.neuron.#{key}")
      fill_in label, with: value
    end
  }
end
