# frozen_string_literal: true

FactoryBot.define do
  factory :user_type do
    active { true }
    type { 'UserType' }
  end
  trait :admin do
    name { 'Administrator' }
  end
  trait :writer do
    name { 'Writer' }
  end
end
