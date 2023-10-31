# frozen_string_literal: true

# User model
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts
  belongs_to :user_type, foreign_key: :user_type_id, required: false

  validates_presence_of :full_name
  validates_presence_of :email

  before_create :set_user_type

  private

  def set_user_type
    return unless user_type.nil?

    self.user_type_id = UserType.find_by(name: 'Writer').id
  end
end
