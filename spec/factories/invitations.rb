FactoryBot.define do
  factory :invitation do
    sequence(:email) { |n| "invitee#{n}@example.com" }
    association :invited_by, factory: :user, role: :admin

    trait :accepted do
      accepted_at { 1.day.ago }
    end
  end
end
