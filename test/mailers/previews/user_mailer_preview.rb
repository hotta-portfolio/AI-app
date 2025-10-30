class UserMailerPreview < ActionMailer::Preview
  # 新規登録メールプレビュー
  def welcome_email
    user = User.first || User.new(name: "テストユーザー", email: "test@example.com")
    UserMailer.welcome_email(user)
  end

  # 購入完了メールプレビュー
  def purchase_completed_email
    user = User.first || User.new(name: "テストユーザー", email: "test@example.com")
    knowhow = Knowhow.first || Knowhow.new(title: "テストノウハウ", price: 1000)
    UserMailer.purchase_completed_email(user, knowhow)
  end
end
