class PostsController < ApplicationController
  before_action :set_post, only: [ :edit, :update, :destroy ]
  before_action :authorize_post, only: [ :edit, :update, :destroy ]
  layout "authenticated"

  def index
    @posts = Post.includes(:user, images_attachments: :blob)
    .where(user: current_user.following + [ current_user ])
    .order(created_at: :desc)
    @post = current_user.posts.build
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path
    else
      flash.now[:alert] = @post.errors.full_messages.join("\n")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to posts_path
    else
      flash.now[:alert]= @post.errors.full_messages.join("\n")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.destroy
      redirect_to posts_path
    else
      redirect_to posts_path, alert: "Something went wrong"
    end
  end

  private

    def post_params
      params.expect(post: [ :title, :body, images: [] ])
    end

    def authorize_post
      return if @post.user == current_user

      redirect_to posts_path, alert: "You are not authorized to do that."
    end

    def set_post
      @post = Post.find(params[:id])
    end
end
