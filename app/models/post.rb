# frozen_string_literal: true

# Post model
class Post < ApplicationRecord
  include MeiliSearch::Rails
  extend Pagy::Meilisearch
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :record, dependent: :destroy
  has_many :notifications, as: :targetable, dependent: :destroy
  belongs_to :post_type
  belongs_to :user
  validates_presence_of :content
  validates_presence_of :title

  has_rich_text :content

  default_scope { order(created_at: :desc) }

  meilisearch do
    attribute :title
    attribute :content do
      content.body.to_plain_text
    end
    attribute :user do
      user.full_name
    end
    attribute :comments do
      comments.map { |comment| comment.body.body.to_plain_text }
    end
    attribute :post_type do
      post_type.name
    end
    filterable_attributes %i[title content]
    sortable_attributes %i[created_at updated_at]
  end

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
