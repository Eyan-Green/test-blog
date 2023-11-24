# frozen_string_literal: true

# app/controller/posts_controller.rb
class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]

  def index
    posts = Post.pagy_search(params[:query])
    @pagy, @posts = pagy_meilisearch(posts, limit: 25)
  rescue Pagy::OverflowError
    redirect_to posts_path(page: 1)
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
      flash.now[:alert] = 'Post could not be created, please try again.'
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      flash.now[:alert] = 'Post could not be updated, please try again.'
      render :edit, status: :unprocessable_entity
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
