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
class User < ApplicationRecord
  acts_as_paranoid

  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Name: must start with a letter, no numbers or special characters allowed
  validates :name, presence: true,
                   format: {
                     with: /\A[a-zA-Z][a-zA-Z\s]*\z/,
                     message: "must start with a letter and contain only letters and spaces"
                   }

  # Password complexity validation (only applied when setting/updating password)
  validates :password, length: { minimum: 6 },
                       format: {
                         with: /(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[[:punct:]])/,
                         message: "must include at least 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character"
                       },
                       allow_nil: true
end
