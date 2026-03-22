FactoryBot.define do
  factory :project do
    association :user, factory: [ :user, :creator ]
    sequence(:title) { |n| "Project #{n}" }
    published { false }

    trait :published do
      published { true }
      published_at { 1.day.ago }
    end

    trait :with_tags do
      after(:create) do |project|
        project.tag_list = "cotton, dress"
        project.save!
      end
    end
  end
end
