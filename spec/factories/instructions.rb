# spec/factories/instructions.rb
FactoryBot.define do
  factory :instruction do
    association :knowhow
    description { "説明テキストです" }

    after(:build) do |instruction|
      # 1x1 PNG ダミー画像
      image_data = StringIO.new(
        Base64.decode64(
          "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII="
        )
      )

      instruction.image.attach(
        io: image_data,
        filename: "instruction.png",
        content_type: "image/png"
      )
    end
  end
end
