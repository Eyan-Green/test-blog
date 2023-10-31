# frozen_string_literal: true

# PostType class inherits from Type
class PostType < Type
  has_many :posts
end
