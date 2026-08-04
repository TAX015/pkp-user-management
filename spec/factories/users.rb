# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  deleted_at      :datetime
#  email           :string           not null
#  name            :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_deleted_at  (deleted_at)
#  index_users_on_email       (email) UNIQUE
#
FactoryBot.define do
  factory :user do
    email { "#{Faker::Internet.unique.email}" }
    name { "Rahmad Riyadi" }
    password { "P4ssword!" }
    password_confirmation { "P4ssword!" }

    trait :deleted do
      deleted_at { Time.current }
    end
  end
end
