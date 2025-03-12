class LikesController < ApplicationController
  before_action :require_login

  def create
    @post = Post.find(params[:post_id])
    @like = @post.likes.create(user: current_user)
  
    respond_to do |format|
      format.html { redirect_to root_path }  # Fallback for non-JS users
      format.turbo_stream  # Turbo replaces HTML dynamically
    end
  end
  

  def destroy
    @post = Post.find(params[:post_id])
    @like = @post.likes.find_by(user: current_user)
    @like.destroy if @like
  
    respond_to do |format|
      format.html { redirect_to root_path }
      format.turbo_stream
    end
  end
  private

  def require_login
    redirect_to login_path, alert: "You must be logged in to like posts" unless logged_in?
  end
end

