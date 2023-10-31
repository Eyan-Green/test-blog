# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title { 'Title' }
    content { 'Content' }
    user_id { User.last.id }
  end
  trait :post_type do
    post_type_id { (PostType.find_by(name: 'Tech') || create(:post_type, :tech)).id }
  end
end
