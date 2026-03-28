FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Test User #{n}-#{SecureRandom.hex(3)}" }
    sequence(:email) { |n| "user#{n}-#{SecureRandom.hex(4)}@example.com" }
    password { "password123" }

    trait :creator do
      sequence(:name) { |n| "Test Creator #{n}-#{SecureRandom.hex(3)}" }
      role { :creator }
    end

    trait :admin do
      sequence(:name) { |n| "Test Admin #{n}-#{SecureRandom.hex(3)}" }
      role { :admin }
    end
  end
end
