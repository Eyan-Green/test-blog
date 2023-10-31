# frozen_string_literal: true

FactoryBot.define do
  factory :post_type do
    type { 'PostType' }
    trait :tech do
      name { 'Tech' }
    end
  end
end
