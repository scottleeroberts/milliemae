FactoryBot.define do
  factory :project_image do
    association :project
    position { 0 }
    image_width { nil }
    image_height { nil }

    after(:build) do |project_image|
      unless project_image.image.attached?
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
