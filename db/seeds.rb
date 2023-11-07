# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
UserType.find_or_create_by!(name: 'Writer')
UserType.find_or_create_by!(name: 'Administrator')
PostType.find_or_create_by!(name: 'Tech')

100.times do |i|
  post = Post.where(title: "Blog post title #{i}").first_or_initialize
  post.update(user_id: User.pluck(:id).sample,
              post_type_id: PostType.last.id,
              content: "I'm baby yes plz vinyl health goth asymmetrical. Tofu poke tousled put a bird on it shabby chic pug PBR&B williamsburg poutine try-hard. Lyft JOMO cred chartreuse readymade occupy activated charcoal. Twee meditation mumblecore helvetica fixie lumbersexual neutra hella, brunch pinterest XOXO keytar forage aesthetic.")
end
