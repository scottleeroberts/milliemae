FactoryBot.define do
  factory :comment do
    association :user
    association :project, factory: [:project, :published]
    body { "A lovely project!" }
  end
end
