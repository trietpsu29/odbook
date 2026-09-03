class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(user: current_user, body: comment_params[:body])
    if @comment.save
      respond_to do |format|
       format.turbo_stream
       format.html { redirect_to posts_path }
     end
    else
      redirect_to posts_path, alert: "Something went wrong"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user != current_user && @comment.post.user != current_user
      redirect_to posts_path,  alert: "You cannot perform this action."
      return
    end
    if @comment.destroy
      respond_to do |format|
       format.turbo_stream
       format.html { redirect_to posts_path }
     end
    else
      redirect_to posts_path, alert: "Something went wrong"
    end
  end

private

  def comment_params
    params.expect(comment: [ :body ])
  end
end
