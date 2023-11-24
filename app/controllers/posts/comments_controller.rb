# frozen_string_literal: true

# nested in posts
module Posts
  # app/controllers/posts/comments_controller.rb
  class CommentsController < ApplicationController
    include Commentable

    before_action :set_commentable

    private

    def set_commentable
      @commentable = Post.find(params[:post_id])
    end
  end
end
