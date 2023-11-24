# frozen_string_literal: true

# app/models/type.rb
class Type < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name
end
