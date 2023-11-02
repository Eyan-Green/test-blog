# frozen_string_literal: true

# Post model
class Post < ApplicationRecord
  has_many :comments, as: :commentable
  belongs_to :user
  belongs_to :post_type
  validates_presence_of :title
  validates_presence_of :content

  has_rich_text :content
end
