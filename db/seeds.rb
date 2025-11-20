# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

# db/seeds.rb

chat_rooms = [ "General", "Random", "Support" ]
chat_rooms.each do |room_name|
  ChatRoom.find_or_create_by(name: room_name)
end

# 必要に応じて管理ユーザーなども追加
# User.find_or_create_by(email: "admin@example.com") { |u| u.password = "password"; u.admin = true }
