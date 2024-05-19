FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    full_name { Faker::Name.name }
    password { Faker::Internet.password(min_length: 8)}
    key { SecureRandom.hex }
    account_key { SecureRandom.hex }
    metadata { Faker::Lorem.paragraph }
  end
end
