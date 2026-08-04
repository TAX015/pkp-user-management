require 'rails_helper'

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
RSpec.describe User, type: :model do
  subject { build(:user) }

  describe "Database & Gem Integrations" do
    it { is_expected.to have_db_column(:email).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:password_digest).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:deleted_at).of_type(:datetime) }

    it { is_expected.to have_secure_password }

    it "handles soft deletes via acts_as_paranoid" do
      user = create(:user)
      user.destroy

      expect(User.find_by(id: user.id)).to be_nil
      expect(User.with_deleted.find_by(id: user.id)).to eq(user)
    end
  end

  describe "Validations" do
    context "when testing presence and uniqueness" do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
    end

    context "when validating email format" do
      it { is_expected.to allow_value("user@example.com", "john.doe@domain.co.id").for(:email) }
      it { is_expected.not_to allow_value("invalid_email", "@domain.com").for(:email) }
    end

    context "when validating name format" do
      it { is_expected.to allow_value("Rahmad", "Rahmad Riyadi", "Muhammad Rizky Firmansyah").for(:name) }

      it "rejects names starting with non-letters or containing numbers/symbols" do
        invalid_names = [ "123Rahmad", " Rahmad", "Rahmad123", "Rahmad_Riyadi", "Nurul-Ardani" ]

        invalid_names.each do |invalid_name|
          user = build(:user, name: invalid_name)
          expect(user).not_to be_valid
          expect(user.errors[:name]).to include("must start with a letter and contain only letters and spaces")
        end
      end
    end

    context "when validating password complexity" do
      it { is_expected.to validate_length_of(:password).is_at_least(6) }

      it "accepts passwords containing uppercase, lowercase, digit, and special character" do
        valid_passwords = [ "P4ssword!", "A1@bcde", "Secret#9" ]

        valid_passwords.each do |valid_password|
          user = build(:user, password: valid_password, password_confirmation: valid_password)
          expect(user).to be_valid
        end
      end

      it "rejects weak passwords missing required complexity rules" do
        invalid_passwords = [
          "p4ssword!", # No uppercase
          "P4SSWORD!", # No lowercase
          "Password!", # No digit
          "P4sswordd"  # No special char
        ]

        invalid_passwords.each do |invalid_password|
          user = build(:user, password: invalid_password, password_confirmation: invalid_password)
          expect(user).not_to be_valid
          expect(user.errors[:password]).to include("must include at least 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character")
        end
      end

      it "allows blank password when updating existing record without changing password" do
        user = create(:user)
        expect(user.update(name: "Updated Name")).to be true
      end
    end
  end
end
