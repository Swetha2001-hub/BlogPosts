class PostsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_post, only: [:edit, :update, :destroy]

  def index
    if params[:query].present?
      @posts = Post.where("title LIKE ?", "%#{params[:query]}%")
    else
      if logged_in?
        
        @posts = Post.order(Arel.sql("CASE WHEN user_id = #{current_user.id} THEN 0 ELSE 1 END, created_at DESC"))
      else
        @posts = Post.order(created_at: :desc)  
      end
    end
  end
  

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, notice: "Post created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to root_path, notice: "Post updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path, notice: "Post deleted successfully!"
  end
  

  private

  def post_params
    params.require(:post).permit(:title, :content,  :image, :category_id)
  end

  def find_post
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_path, alert: "Not authorized!" if @post.nil?
  end

  def require_login
    redirect_to login_path, alert: "You must be logged in to access this section" unless logged_in?
  end
end
