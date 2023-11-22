# frozen_string_literal: true

# app/models/notification.rb
class Notification < ApplicationRecord
  belongs_to :actor, foreign_key: :actor_id, class_name: 'User'
  belongs_to :user
  belongs_to :targetable, polymorphic: true

  default_scope { order({ created_at: :desc }) }

  after_create_commit do
    broadcast_notification
  end

  private

  def broadcast_notification
    broadcast_replace_to [:notifications],
                         target: 'notifications_list',
                         partial: 'shared/notifications',
                         locals: { current_user: user }
  end
end
