# frozen_string_literal: true

# Posts controller
class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]

  def index
    @posts = Post.all
    @pagy, @posts = pagy(@posts)
  end

  def show; end

  def new
    authorize @post = Post.new
  end

  def edit; end

  def create
    authorize @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @post.delete
    redirect_to posts_path, notice: 'Post was successfully deleted.'
  end

  private

  def set_post
    authorize @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title,
                                 :content,
                                 :user_id,
                                 :post_type_id)
  end
end
