# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
require 'faker'
UserType.find_or_create_by!(name: 'Writer')
UserType.find_or_create_by!(name: 'Administrator')
PostType.find_or_create_by!(name: 'Tech')

100.times do
  pw = Devise.friendly_token[0, 20]
  User.create(full_name: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
              email: Faker::Internet.email,
              password: pw,
              password_confirmation: pw)
end
