require "rails_helper"

describe "neurons as curador" do
  let!(:current_user) { create :user, :curador }

  before {
    login_as current_user
  }

  context "with forms" do
    include_context "form features"
    include_context "neuron form features"

    feature "curador can create neurons", js: true do
      before {
        visit new_admin_neuron_path
        fill_form!
        expect {
          submit_form!
        }.to change{ Neuron.count }.by(1)
      }

      it {
        expect(page).to have_text(I18n.t("views.neurons.created"))
      }
    end

    feature "curador can add contents through neurons", js: true do
      let(:created_neuron) { Neuron.last }
      let(:created_content) { created_neuron.contents.first }
      let(:description) { "First content description" }
      let(:source) { "some source" }

      before {
        visit new_admin_neuron_path
        fill_form!
        select_contents_tab!
        first_textarea.set description
        source_input.set source
      }

      it "creates content" do
        expect {
          submit_form!
        }.to change{ Content.count }.by(1)
      end

      it "assigns description" do
        submit_form!
        expect(created_content.description).to eq(description)
      end

      feature "curador can add content links through neurons" do
        let(:created_link) {
          created_content.content_links.first
        }
        let(:link) {
          attributes_for(:content_link)[:link]
        }
        let(:link_input) {
          all("input[name*='[link]']").first
        }

        before {
          link_input.set link
        }

        it "creates content link" do
          expect {
            submit_form!
          }.to change { ContentLink.count }.by(1)
        end

        it "assigns link" do
          submit_form!
          expect(created_link.link).to eq(link)
        end
      end

      feature "curador can add content video through neuron" do
        let(:created_video) {
          created_content.content_videos.first
        }
        let(:url) {
          attributes_for(:content_video)[:url]
        }
        let(:url_input) {
          all("input[name*='[url]']").first
        }

        before {
          url_input.set url
        }

        it "creates video" do
          expect {
            submit_form!
          }.to change { ContentVideo.count }.by(1)
        end

        it "assigns url" do
          submit_form!
          expect(created_video.url).to eq(url)
        end
      end
    end

    feature "created neuron is shown in tree", js: true do
      before {
        visit new_admin_neuron_path
        fill_form!
        submit_form!
      }

      it {
        expect(page).to have_text(I18n.t("views.neurons.created"))
        expect(page).to have_text(neuron_attrs[:title])
      }
    end

    feature "update neuron", js: true do
      let!(:existing_neuron) { create :neuron }

      before {
        visit edit_admin_neuron_path(existing_neuron)
        fill_form!
        expect {
          submit_form!
        }.to_not change(Neuron, :count)
      }

      it {
        expect(page).to have_text(I18n.t("views.neurons.updated"))
      }

      it "change is reflected in tree", js: true do
        expect(page).to have_text(neuron_attrs[:title])
      end
    end

    feature "curador can update contents through neurons", js: true do
      let(:content) {
        build :content, level: Content::LEVELS.first,
                        kind: Content::KINDS.first
      }
      let!(:neuron) {
        create :neuron, contents: [content]
      }
      let(:description) { "New content's description" }

      before {
        visit edit_admin_neuron_path(neuron)
        select_contents_tab!
        find("textarea").set description
        expect {
          submit_form!
        }.to_not change(Content, :count)
      }

      it {
        expect(
          neuron.contents.reload.first.description
        ).to eq(description)
      }
    end

    feature "curador can remove contents through neurons", js: true do
      let(:content) {
        build :content, level: Content::LEVELS.first,
                        kind: Content::KINDS.first
      }
      let!(:neuron) {
        create :neuron, contents: [content]
      }

      before {
        visit edit_admin_neuron_path(neuron)
        select_contents_tab!
        find(".remove_nested_fields[data-association='contents']").click
        expect {
          submit_form!
        }.to change{ Content.count }.by(-1)
      }

      it {
        expect(neuron.contents.reload).to be_empty
      }
    end


  end
end
