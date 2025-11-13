# spec/factories/knowhows.rb
FactoryBot.define do
  factory :knowhow do
    association :user
    title { "Sample Knowhow" }
    description { "This is a description." }
    category_type { :video }
    price { 1000 }
    software { "Adobe Premiere" }

    after(:build) do |knowhow|
      # ダミー画像を生成（1x1 ピクセル PNG）
      image_data = StringIO.new(
        Base64.decode64(
          "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII="
        )
      )
      knowhow.thumbnail.attach(
        io: image_data,
        filename: "dummy.png",
        content_type: "image/png"
      )

      # media_files 添付サンプル（複数ファイル）
      2.times do |i|
        media_data = StringIO.new(
          Base64.decode64(
            "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII="
          )
        )
        knowhow.media_files.attach(
          io: media_data,
          filename: "dummy_#{i}.png",
          content_type: "image/png"
        )
      end
    end
  end
end
