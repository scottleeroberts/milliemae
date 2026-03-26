FactoryBot.define do
  factory :invitation do
    sequence(:email) { |n| "invitee#{n}@example.com" }
    association :invited_by, factory: [:user, :admin]

    trait :accepted do
      accepted_at { 1.day.ago }
    end

    trait :expired do
      expires_at { 1.hour.ago }
    end
  end
end
