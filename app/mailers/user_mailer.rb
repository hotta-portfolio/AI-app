class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "ようこそ！")
  end

  def purchase_completed_email(user, knowhow)
    @user = user
    @knowhow = knowhow
    mail(to: @user.email, subject: "購入が完了しました")
  end
end
