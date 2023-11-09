# Preview all emails at http://localhost:3000/rails/mailers/comment
class CommentPreview < ActionMailer::Preview
  def new_comment
    CommentMailer.with(user: User.first, post: Post.first).new_comment
  end
end
