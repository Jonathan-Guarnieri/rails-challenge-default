class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, length: { maximum: 200 }
  validates :phone_number, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :full_name, length: { maximum: 200 }, allow_blank: true
  validates :password, presence: true, length: { maximum: 100 }
  validates :key, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :account_key, uniqueness: true, length: { maximum: 100 }, allow_blank: true
  validates :metadata, length: { maximum: 2000 }, allow_blank: true
end
