# frozen_string_literal: true

# Post model
class Post < ApplicationRecord
  has_many :comments, as: :commentable
  has_many :likes, as: :record
  belongs_to :post_type
  belongs_to :user
  validates_presence_of :content
  validates_presence_of :title

  has_rich_text :content

  default_scope { order(created_at: :desc) }

  def liked_by?(user)
    likes.where(user: user).any?
  end

  def like(user)
    likes.where(user: user).first_or_create
  end

  def unlike(user)
    likes.where(user: user).destroy_all
  end
end
