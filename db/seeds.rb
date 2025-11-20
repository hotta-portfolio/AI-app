# db/seeds.rb

# ----------------------------------------
# Dummy Knowhow
# ----------------------------------------
dummy_knowhow = Knowhow.first
unless dummy_knowhow
  dummy_knowhow = Knowhow.create!(
    title: "Dummy Knowhow",
    description: "This is a placeholder knowhow for seeding.",
    user_id: User.first&.id || 1  # ユーザーが存在すれば使う、いなければ仮ID 1
  )
  puts "Created dummy knowhow: #{dummy_knowhow.title}"
end

# ----------------------------------------
# Dummy Purchase
# ----------------------------------------
dummy_purchase = Purchase.first
unless dummy_purchase
  dummy_purchase = Purchase.create!(
    knowhow: dummy_knowhow,
    user_id: User.last&.id || 2,   # 購入者として適当なユーザーID
    amount: 100                     # 仮の金額
  )
  puts "Created dummy purchase for knowhow #{dummy_knowhow.title}"
end

# ----------------------------------------
# ChatRoom
# ----------------------------------------
chat_room = ChatRoom.find_or_create_by!(name: "General") do |room|
  room.knowhow = dummy_knowhow
  room.purchase = dummy_purchase
end
puts "ChatRoom ready: #{chat_room.name}"

# ----------------------------------------
# ここに他の seed データがあれば続けて追加
# ----------------------------------------
