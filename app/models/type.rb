# frozen_string_literal: true

# Type model, associations are on classes that inherit from this
class Type < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name
end
