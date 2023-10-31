# frozen_string_literal: true

# Inherits from Type
class UserType < Type
  has_many :users
end
