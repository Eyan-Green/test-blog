# frozen_string_literal: true

require 'faker'
FactoryBot.define do
  factory :user do
    pw = Devise.friendly_token[0, 20]
    full_name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    email { Faker::Internet.email }
    password { pw }
    password_confirmation { pw }
    trait :admin do
      user_type_id { (UserType.find_by(name: 'Administrator') || create(:user_type, :admin)).id }
    end
    trait :writer do
      user_type_id { (UserType.find_by(name: 'Writer') || create(:user_type, :writer)).id }
    end
  end
end
