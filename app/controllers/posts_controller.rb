class PostsController < ApplicationController
  #before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:edit, :update, :destroy ]

	def index
		@posts = Post.all.where(published: true)
	end

  def show
		@post = Post.find(params[:id])
	end

  def new
		@post = Post.new
	end

  def create
		authorize Post
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

	def myposts
		@posts = Post.where(user_id: current_user.id, published: true)
		authorize @posts
	end

	def mydrafts
		@posts = Post.where(user_id: current_user.id, published: false)
		authorize @posts
	end

  def edit
	end

	def up_rate_post
		@post = Post.find(params[:post_id])
		user_id = current_user.id.to_s

		if @post.up_rate.include?(user_id)
			nil
		else
			if @post.down_rate.include?(user_id)
				@post.down_rate.delete(user_id)
			end
			@post.up_rate.push(user_id)
		end

		@post.save
		redirect_to @post, success: 'Действие успешно выполнено.'
	end

	def down_rate_post
		@post = Post.find(params[:post_id])
		user_id = current_user.id.to_s

		if @post.down_rate.include?(user_id)
			nil
		else
			if @post.up_rate.include?(user_id)
				@post.up_rate.delete(user_id)
			end
			@post.down_rate.push(user_id)
		end

		@post.save
		redirect_to @post, success: 'Действие успешно выполнено.'
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
		@post.destroy
		redirect_to posts_path, success: 'Статья успешно удалена'
	end

  private

  def set_post
		@post = Post.find(params[:id])
		authorize @post
	end

  def post_params
		req_body = params.require(:post).permit(:title, :summary, :body, :image, :remove_image, :image_cache)
		req_body[:user_id] = current_user.id

		req_body
	end
end