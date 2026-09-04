class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @like = @post.likes.build(user: current_user)
    if @like.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to posts_path }
      end
    else
      redirect_to posts_path, alert: "Something went wrong"
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @like = @post.likes.find(params[:id])
    if @like.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to posts_path }
      end
    else
      redirect_to posts_path, alret: @like.errors.full_messages.join("\n")
    end
  end
end
