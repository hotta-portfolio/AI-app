class AddPrimaryKeyToMessages < ActiveRecord::Migration[8.0]
  def up
    # 既存 id の重複を確認しつつ PRIMARY KEY を追加
    # 重複がある場合は raise して止める
    duplicates = ActiveRecord::Base.connection.execute(<<~SQL).to_a
      SELECT id, COUNT(*)#{' '}
      FROM messages#{' '}
      GROUP BY id#{' '}
      HAVING COUNT(*) > 1;
    SQL

    raise "Duplicate IDs found in messages: #{duplicates}" if duplicates.any?

    # id に PRIMARY KEY を追加
    execute "ALTER TABLE messages ADD PRIMARY KEY (id);"

    # シーケンスを最大 id に合わせる
    max_id = ActiveRecord::Base.connection.execute("SELECT MAX(id) FROM messages;").first['max']
    execute "SELECT setval('messages_id_seq', #{max_id});"
  end

  def down
    execute "ALTER TABLE messages DROP CONSTRAINT messages_pkey;"
  end
end
