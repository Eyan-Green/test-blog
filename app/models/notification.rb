# frozen_string_literal: true

# app/models/notification.rb
class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :actor, foreign_key: :actor_id, class_name: 'User'
end
