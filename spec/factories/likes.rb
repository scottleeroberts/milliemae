FactoryBot.define do
  factory :like do
    association :user
    association :project, factory: [:project, :published]
  end
end
