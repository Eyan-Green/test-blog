# frozen_string_literal: true

# app/models/user_type.rb
class UserType < Type
  has_many :users
end
