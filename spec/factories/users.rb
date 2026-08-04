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
    email { "MyString" }
    name { "MyString" }
    password_digest { "MyString" }
    deleted_at { "2026-08-04 21:45:30" }
  end
end
