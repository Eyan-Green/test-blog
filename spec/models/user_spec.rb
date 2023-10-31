# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe User, type: :model do
  let(:writer_user_type) { create(:user_type, :writer) }
  let(:pw) { Devise.friendly_token[0, 20] }
  let(:name) { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
  let(:email_address) { Faker::Internet.email }

  describe 'Associations' do
    it 'should have many posts' do
      t = User.reflect_on_association(:posts)
      expect(t.macro).to eq(:has_many)
    end
    it 'should belong to user type' do
      t = User.reflect_on_association(:user_type)
      expect(t.macro).to eq(:belongs_to)
    end
  end

  describe 'Validations' do
    it 'should validate the presence of full_name' do
      user = User.new(full_name: nil,
                      email: email_address,
                      password: pw,
                      password_confirmation: pw)
      user.valid?
      expect(user.errors.full_messages).to include('Full name can\'t be blank')
    end

    it 'should validate the presence of email' do
      user = User.new(full_name: name,
                      email: nil,
                      password: pw,
                      password_confirmation: pw)
      user.valid?
      expect(user.errors.full_messages).to include('Email can\'t be blank')
    end

    it 'password is invalid if it\'s less than 10 characters' do
      invalid_pw = Devise.friendly_token[0, 9]
      user = User.new(full_name: name,
                      email: email_address,
                      password: invalid_pw,
                      password_confirmation: invalid_pw)
      user.valid?
      message = 'Password is too short (minimum is 10 characters)'
      expect(user.errors.full_messages).to include(message)
    end

    it 'validates uniqueness of user email' do
      user = create(:user, :writer)
      user2 = User.new(full_name: name,
                       email: user.email,
                       password: pw,
                       password_confirmation: pw,
                       user_type_id: user.user_type_id)
      user2.valid?
      message = 'Email has already been taken'
      expect(user2.errors.full_messages).to include(message)
    end
  end

  describe 'Class methods' do
    it 'returns user' do
      user = create(:user, :writer, uid: '0123456789', provider: 'google')
      expect(User.from_omniauth(user)).to eq(user)
    end
  end

  describe 'Callbacks' do
    it 'adds writer user type by default' do
      writer_user_type
      user = User.new(full_name: name,
                      email: email_address,
                      password: pw,
                      password_confirmation: pw)
      user.save
      expect(user.user_type_id).to eq(writer_user_type.id)
    end
  end
end
