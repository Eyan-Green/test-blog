# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
UserType.find_or_create_by!(name: 'Writer')
UserType.find_or_create_by!(name: 'Administrator')
PostType.find_or_create_by!(name: 'Tech')

User.all.each do |user|
  if user.name == 'Ian Green'
    user.update_column(:user_type_id, UserType.find_by(name: 'Administrator').id)
  else
    user.update_column(:user_type_id, UserType.find_by(name: 'Writer').id)
  end
end
