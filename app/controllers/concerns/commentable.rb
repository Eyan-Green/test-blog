# frozen_string_literal: true

# app/controller/concerns/commentable.rb
module Commentable
  extend ActiveSupport::Concern
  include ActionView::RecordIdentifier
  include RecordHelper

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.parent_id = @parent&.id

    respond_to do |format|
      if @comment.save
        new_comment = Comment.new
        NotificationService.new(current_user, @commentable, @comment.reply_to_comment_or_post).create_new_notification
        CommentMailer.with(user: @commentable.user, post: @commentable).new_comment.deliver_later
        format.turbo_stream do
          if @parent
            render turbo_stream: turbo_stream.replace(dom_id_for_records(@parent, new_comment),
                                                      partial: 'comments/form',
                                                      locals: { comment: new_comment,
                                                                commentable: @parent,
                                                                data: {
                                                                  comment_reply_target: :form
                                                                }, class: 'hidden' })
          else
            render turbo_stream: turbo_stream.replace(dom_id_for_records(@commentable, new_comment),
                                                      partial: 'comments/form',
                                                      locals: { comment: new_comment,
                                                                commentable: @commentable })
          end
        end
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(dom_id_for_records(@parent || @commentable, @comment),
                                                    partial: 'comments/form',
                                                    locals: { comment: @comment,
                                                              commentable: @parent || @commentable })
        end
        format.html { redirect_to @commentable }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
