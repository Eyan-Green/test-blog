class CommentMailer < ApplicationMailer
  def new_comment
    @user = params[:user]
    @post = params[:post]
    mail(to: @user.email, subject: 'New comment on your post')
  end
end
