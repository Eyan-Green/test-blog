# frozen_string_literal: true

# app/models/like.rb
class Like < ApplicationRecord
  include ActionView::RecordIdentifier
  belongs_to :record, polymorphic: true, counter_cache: true
  belongs_to :user

  after_create_commit do
    broadcast_replace_to [record, :likes], target: "#{dom_id(record, :likes)}_count", partial: 'posts/likes_count', locals: { post: record }
  end

  after_destroy_commit do
    broadcast_replace_to [record, :likes], target: "#{dom_id(record, :likes)}_count", partial: 'posts/likes_count', locals: { post: record }
  end
end
