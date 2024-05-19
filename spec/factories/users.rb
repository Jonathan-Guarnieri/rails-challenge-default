FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    phone_number { Faker::PhoneNumber.unique.cell_phone_in_e164[1..20] }
    full_name { Faker::Name.name }
    password { Faker::Internet.password(min_length: 8, max_length: 100) }
    key { SecureRandom.hex(10) }
    account_key { SecureRandom.hex(10) }
    metadata { Faker::Lorem.characters(number: 2000) }
  end
end
