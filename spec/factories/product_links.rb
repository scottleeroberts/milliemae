FactoryBot.define do
  factory :product_link do
    association :project_image
    label { "Test Product" }
    url { "https://example.com/product" }
    x { 0.25 }
    y { 0.35 }
  end
end
