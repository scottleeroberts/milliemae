FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Test User #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }

    trait :creator do
      sequence(:name) { |n| "Test Creator #{n}" }
      role { :creator }
    end

    trait :admin do
      sequence(:name) { |n| "Test Admin #{n}" }
      role { :admin }
    end
  end
end
