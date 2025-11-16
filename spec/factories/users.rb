# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    name { "Test User" }
    email { Faker::Internet.unique.email }
    password { "password" }
    password_confirmation { "password" }

    # ここで avatar を添付する
    after(:build) do |user|
      # 1x1px の透明PNG
      image_data = StringIO.new(
        Base64.decode64(
          "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII="
        )
      )

      user.avatar.attach(
        io: image_data,
        filename: "avatar.png",
        content_type: "image/png"
      )
    end
  end
end
