# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    user { (User.last || create(:user, :writer)) }
    commentable { (Post.last || create(:post, :post_type)) }
    parent_id { (Post.last || create(:post, :post_type)).id }
    body { 'This is a comment' }
  end
end
