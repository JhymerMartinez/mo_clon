# == Schema Information
#
# Table name: content_notes
#
#  id         :integer          not null, primary key
#  content_id :integer          not null
#  user_id    :integer          not null
#  note       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ContentNote,
               type: :model do
  describe "factory" do
    subject { build :content_note }
    it { is_expected.to be_valid }
    it {
      expect(subject.user).to be_present
    }
    it {
      expect(subject.content).to be_present
    }
    it {
      expect(subject.note).to be_present
    }
  end

  describe User::UserContentAnnotable do
    let(:user) { create :user }
    let(:content) { create :content }

    describe "unannotate_content doesn't fatal" do
      it "without notes" do
        expect {
          user.unannotate_content!(content)
        }.to_not change(ContentNote, :count)
      end

      it "destroys actual notes" do
        expect {
          user.annotate_content(content, "something")
        }.to change { ContentNote.count }.by(1)
        expect {
          user.unannotate_content!(content)
        }.to change { ContentNote.count }.by(-1)
      end
    end
  end
end
