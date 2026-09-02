class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @like = @post.likes.build(user: current_user)
    if @like.save
      redirect_to posts_path
    else
      redirect_to posts_path, alert: "Something went wrong"
    end
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    if @like.destroy
      redirect_to posts_path
    else
      redirect_to posts_path, alret: "Something went wrong"
    end
  end
end
