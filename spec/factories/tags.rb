FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "tag#{n}-#{SecureRandom.hex(2)}" }
  end
end
