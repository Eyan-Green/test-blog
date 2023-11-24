# frozen_string_literal: true

# app/models/post_type.rb
class PostType < Type
  has_many :posts
end
