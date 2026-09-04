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
      respond_to do |format|
        flash[:alert] = @post.errors.full_messages.join("\n")

        if @post.errors[:images].any?
          flash[:alert] += "\n\nPlease select another image, or save your text content and reload the page to clear the current selection."
        end
        format.turbo_stream { render status: :unprocessable_entity }
        format.html { redirect_to posts_path, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    new_images = params[:post][:images]&.reject(&:blank?)

    params[:post].delete(:images)

    if @post.update(post_params)
      @post.images.attach(new_images) if new_images.present?
      respond_to do |format|
       format.turbo_stream
       format.html { redirect_to posts_path }
     end
    else
      respond_to do |format|
       flash.now[:alert] = @post.errors.full_messages.join("\n")

       format.turbo_stream { render status: :unprocessable_entity }
       format.html { redirect_to posts_path, status: :unprocessable_entity }
     end
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
      permitted = params.expect(post: [ :title, :body, images: [] ])

      if permitted[:images]&.all?(&:blank?)
        permitted.delete(:images)
      end

      permitted
    end

    def authorize_post
      return if @post.user == current_user

      redirect_to posts_path, alert: "You are not authorized to do that."
    end

    def set_post
      @post = Post.find(params[:id])
    end
end
