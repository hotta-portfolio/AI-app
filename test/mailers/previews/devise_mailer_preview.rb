class DeviseMailerPreview < ActionMailer::Preview
  def reset_password_instructions
    user = User.first || User.new(email: "sample@example.com")
    token = "fake-token-123"
    Devise::Mailer.reset_password_instructions(user, token)
  end

  def password_change
    user = User.first || User.new(email: "sample@example.com")
    Devise::Mailer.password_change(user)
  end

  def email_changed
    user = User.first || User.new(email: "sample@example.com")
    Devise::Mailer.email_changed(user)
  end
end
