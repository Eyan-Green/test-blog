# frozen_string_literal: true

# Comments controller, create action is in concerns
class CommentsController < ApplicationController
  before_action :set_comment

  def show; end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to @comment
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.turbo_stream {}
      format.html { redirect_to @comment.commentable }
    end
  end

  private

  def set_comment
    authorize @comment = current_user.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
