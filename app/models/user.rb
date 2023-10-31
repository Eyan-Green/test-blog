# frozen_string_literal: true

# User model
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :posts
  belongs_to :user_type, foreign_key: :user_type_id, required: false

  validates_presence_of :full_name
  validates_presence_of :email
  validates_uniqueness_of :email

  before_create :set_user_type

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth.info.name
    end
  end

  private

  def set_user_type
    return unless user_type.nil?

    self.user_type_id = UserType.find_by(name: 'Writer').id
  end
end
