# frozen_string_literal: true

# User model
class User < ApplicationRecord
  include MeiliSearch::Rails
  extend Pagy::Meilisearch
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :comments
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :posts
  has_many :sent_notifications, foreign_key: :actor_id, class_name: 'Notification'
  belongs_to :user_type, foreign_key: :user_type_id, required: false

  validates :full_name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true

  before_create :set_user_type

  meilisearch do
    attribute :email
    attribute :full_name
    filterable_attributes [:full_name]
    sortable_attributes [:created_at]
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth.info.name
    end
  end

  def unread_notifications
    notifications.where(read: false)
  end

  private

  def set_user_type
    return unless user_type.nil?

    self.user_type_id = UserType.find_by(name: 'Writer').id
  end
end
