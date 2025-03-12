class CommentsController < ApplicationController
  before_action :require_login
  before_action :find_comment, only: [:edit, :update, :destroy]

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to root_path, notice: "Comment addded successfully!"
    else
      redirect_to root_path, alert: "Comment cannot be empty."
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to root_path, notice: "Comment updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to root_path, notice: "Comment deleted successfully!"
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def find_comment
    @comment = current_user.comments.find_by(id: params[:id])
    redirect_to root_path, alert: "Not authorized!" if @comment.nil?
  end

  def require_login
    redirect_to login_path, alert: "You must be logged in to comment" unless logged_in?
  end
end
