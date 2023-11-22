# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    type_of_notification { 'new_comment_on_post' }
    read { false }
    targetable_id { (Post.last || create(:post, :post_type)).id }
    targetable_type { 'Post' }
    user_id { create(:user, :admin).id }
    actor_id { create(:user, :writer).id }
  end
end
