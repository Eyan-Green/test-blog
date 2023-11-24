# frozen_string_literal: true

# Nested comments controller
module Comments
  # app/controller/posts/comments_controller.rb
  class CommentsController < ApplicationController
    include Commentable

    before_action :set_commentable

    private

    def set_commentable
      @parent = Comment.find(params[:comment_id])
      @commentable = @parent.commentable
    end
  end
end
