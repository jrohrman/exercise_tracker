require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      user.email = nil
      expect(user).not_to be_valid
    end

    it 'is not valid with a duplicate email' do
      original_user = create(:user, email: 'test@example.com')
      duplicate_user = build(:user, email: 'test@example.com')
      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:email]).to include('has already been taken')
    end

    it 'is not valid with a short password' do
      user.password = user.password_confirmation = '12345'
      expect(user).not_to be_valid
    end

    it 'is case-insensitive with emails' do
      original_user = create(:user, email: 'TEST@example.com')
      duplicate_user = build(:user, email: 'test@example.com')
      expect(duplicate_user).not_to be_valid
    end
  end

  describe '#generate_token' do
    it 'generates a token before saving' do
      user.save
      expect(user.token).not_to be_nil
    end

    it 'does not change token if one exists' do
      user.save
      original_token = user.token
      user.update(email: 'new@example.com')
      expect(user.token).to eq(original_token)
    end
  end
end 