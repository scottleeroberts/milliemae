FactoryBot.define do
  factory :user do
    name { "Test User" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    role { :audience }

    trait :creator do
      name { "Test Creator" }
      role { :creator }
    end

    trait :admin do
      name { "Test Admin" }
      role { :admin }
    end
  end
end
