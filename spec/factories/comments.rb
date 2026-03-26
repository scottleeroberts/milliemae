FactoryBot.define do
  factory :comment do
    association :user
    association :project, factory: [:project, :published]
    sequence(:body) { |n| "A lovely project comment #{n}!" }
  end
end
