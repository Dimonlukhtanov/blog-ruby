class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.author_id = current_user.id
    user = User.find(current_user.id)
    @comment.username = user.username.to_s

    @post.save
    redirect_to post_path(@post), success: 'Комментарий успешно добавлен'
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy

    redirect_to post_path(@post), success: 'Комментарий успешно удален'
  end

  def comment_params
    params.require(:comment).permit(:username, :body)
  end
end
