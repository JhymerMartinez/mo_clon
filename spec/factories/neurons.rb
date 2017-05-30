# == Schema Information
#
# Table name: neurons
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  active     :boolean          default(FALSE)
#  deleted    :boolean          default(FALSE)
#  is_public  :boolean          default(FALSE)
#  position   :integer          default(0)
#

FactoryGirl.define do
  factory :neuron do
    sequence(:title) { |n| "Neurona #{n}" }

    trait :active do
      active true
    end

    trait :inactive do
      active false
    end

    trait :deleted do
      deleted true
    end

    trait :public do
      is_public true
    end

    trait :not_public do
      is_public false
    end

    trait :with_parent do
      parent { create(:neuron) }
    end

    trait :with_content do
      after(:create) do |neuron|
        create :content,
               neuron: neuron
      end
    end

    trait :with_approved_content do
      after(:create) do |neuron|
        create :content,
               :approved,
               neuron: neuron
      end
    end

    factory :neuron_visible_for_api,
            traits: [:public, :with_approved_content]
  end
end
