# frozen_string_literal: true

FactoryBot.define do
  factory :like do
    user { create(:user, :writer) }
    record { create(:post, :post_type) }
  end
end
