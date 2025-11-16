FactoryBot.define do
  factory :purchase do
    association :user
    association :knowhow
  end
end
