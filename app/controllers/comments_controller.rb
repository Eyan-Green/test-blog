# frozen_string_literal: true

# app/controller/comments_controller.rb
# create action is in concerns folder
class CommentsController < ApplicationController
  before_action :set_comment

  def show; end

  def edit; end

  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = 'Comment was successfully updated.' }
        format.html { redirect_to @comment }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = 'Comment was successfully deleted.' }
      format.html { redirect_to @comment.commentable }
    end
  end

  private

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
