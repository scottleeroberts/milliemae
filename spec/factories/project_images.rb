FactoryBot.define do
  factory :project_image do
    association :project
    position { 0 }
    image_width { nil }
    image_height { nil }

    transient do
      attach_image { true }
    end

    trait :without_image do
      attach_image { false }
    end

    after(:build) do |project_image, evaluator|
      if evaluator.attach_image && !project_image.image.attached?
        png_bytes = Base64.decode64(
          "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg=="
        )
        project_image.image.attach(
          io: StringIO.new(png_bytes),
          filename: "test.png",
          content_type: "image/png"
        )
      end
    end
  end
end
