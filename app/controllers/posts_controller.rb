class PostsController < ApplicationController

  before_action :set_post, only: [ :show, :edit, :update, :destroy ]

	def index
		@posts = Post.all
	end

  def show
	end

  def new
		@post = Post.new
	end

  def create
		@post = Post.new(post_params)
		if @post.save
			if params[:new_draft]
				@post.update(published: false)
				redirect_to @post, success: 'Добавлено в черновики'
			else
				redirect_to @post, success: 'Статья успешно создана'
			end
		else
			flash.now[:danger] = 'Статья не создана'
			render :new
		end
	end

  def edit
	end

  def update
		if @post.update(post_params)
			if params[:new_draft]
				@post.update(published: false)
				redirect_to @post, success: 'Добавлено в черновики'
			else
				if params[:new_post]
					@post.update(published: true)
					redirect_to @post, success: 'Опубликовано'
				else
					redirect_to @post, success: 'Статья успешно обновлена'
				end
			end
		else
			flash.now[:danger] = 'Статья не обновлена'
			render :edit
		end
	end

  def destroy
		@post = Post.find(params[:id])
		@post.destroy
		redirect_to posts_path, success: 'Статья успешно удалена'
	end

  private

  def set_post
		@post = Post.find(params[:id])
	end

  def post_params
		params.require(:post).permit(:title, :summary, :body, :image, :remove_image, :image_cache)
	end
end