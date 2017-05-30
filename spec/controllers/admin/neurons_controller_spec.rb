require "rails_helper"

RSpec.describe Admin::NeuronsController,
               type: :controller do
  describe "#formatted_contents" do
    let!(:current_user) {
      create :user, :admin
    }

    before {
      sign_in current_user
      get :new
    }

    describe "format" do
      # {
      #   level1 =>
      #     {
      #       kind1 => [ content1, content2, ... ],
      #       kind2 => [ content3, content4, ... ]
      #     },
      #   ...
      # }
      #
      Content::LEVELS.each do |level|
        it "level #{level}" do
          expect(
            controller.formatted_contents
          ).to have_key(level)
        end

        Content::KINDS.each do |kind|
          it "level #{level} - kind #{kind}" do
            expect(
              controller.formatted_contents[level]
            ).to have_key(kind)
          end
        end
      end
    end
  end

  describe "neuron scope" do
    subject { controller.neurons }

    let!(:active_neuron) { create :neuron, active: true }
    let!(:inactive_neuron) { create :neuron }
    let!(:deleted_neuron) { create :neuron, deleted: true }

    describe "as admin" do
      let!(:admin) {
        create :user, :admin
      }

      before {
        sign_in admin
        get :index, format: :json
      }

      it {
        is_expected.to include(inactive_neuron)
      }
      it {
        is_expected.to include(active_neuron)
      }
      it {
        is_expected.to include(deleted_neuron)
      }
      it {
        # json includes a deleted neuron
        expect(response.body).to include("\"deleted\":true")
      }
    end

    describe "as curador" do
      let!(:curador) {
        create :user, :curador
      }

      describe "#neurons" do
        before {
          sign_in curador
          get :index
        }

        it {
          is_expected.to include(active_neuron)
        }
        it {
          is_expected.to_not include(deleted_neuron)
        }
      end

      describe "#neuron" do
        subject { controller.neuron }

        before {
          sign_in curador
        }

        it {
          expect {
            get :show, id: deleted_neuron.id
          }.to raise_error(ActiveRecord::RecordNotFound)
        }

        it {
          get :show, id: active_neuron.id
          is_expected.to eq(active_neuron)
        }
      end
    end
  end

  describe "admin actions" do
    let!(:admin) { create :user, :admin }

    before { sign_in admin }

    describe "#delete" do
      let!(:neuron) { create :neuron }
      before { post :delete, id: neuron.id }
      it { expect(neuron.reload).to be_deleted }
    end

    describe "#restore" do
      let!(:neuron) { create :neuron }
      before { post :restore, id: neuron.id }
      it { expect(neuron.reload).to_not be_deleted }
    end
  end
end
