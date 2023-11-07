class Posts::LikesController < ApplicationController
  before_action :set_post
  include ActionView::RecordIdentifier

  def update
    if @post.liked_by?(current_user)
      @post.unlike(current_user)
    else
      @post.like(current_user)
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(dom_id(@post, :likes), partial: 'posts/likes', locals: { post: @post })
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
