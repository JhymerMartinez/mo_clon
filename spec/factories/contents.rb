# == Schema Information
#
# Table name: contents
#
#  id          :integer          not null, primary key
#  level       :integer          not null
#  kind        :string           not null
#  description :text             not null
#  neuron_id   :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  source      :string
#  approved    :boolean          default(FALSE)
#  title       :string
#  media_count :integer          default(0)
#

FactoryGirl.define do
  factory :content do
    neuron

    level { Content::LEVELS.sample }
    kind { Content::KINDS.sample }
    sequence(:title) { |n|
      "Content #{n}"
    }
    sequence(:description) { |n|
      "Content's description #{n}"
    }
    sequence(:source) { |n|
      "Content's source #{n}"
    }

    trait :with_keywords do
      keyword_list {
        1.upto(10).map do |i|
          "keyword#{i}"
        end.sample(2).join(", ")
      }
    end

    trait :approved do
      after(:create) do |content|
        content.update! approved: true
        content.neuron.reload.touch
      end
    end

    trait :with_media do
      after(:create) do |content|
        create(:content_media, content: content)
      end
    end

    trait :with_possible_answers do
      after(:create) do |content|
        3.times do
          create :possible_answer, content: content
        end
      end
    end

    trait :with_correct_possible_answers do
      after(:create) do |content|
        3.times do
          create :possible_answer, :correct, content: content
        end
      end
    end
  end
end
