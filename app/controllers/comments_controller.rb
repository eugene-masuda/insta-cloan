class CommentsController < ApplicationController
  before_action :logged_in_user
  
  def create
    @micropost = Micropost.find(params[:micropost_id])
    @comment = 
    Comment.new(user_id: current_user.id, 
                micropost_id: @micropost.id,
                content: params[:comment][:content])
    if @comment && @comment.save
      flash[:success] = "コメントを投稿しました！"
      redirect_to @micropost
    else
      @user = @micropost.user
      @comments = @micropost.comments.all
      render "microposts/show"
    end
  end

  def destroy
    flash[:success] = "コメントを削除しました。"
    redirect_to micropost_path(Comment.find(params[:id]).micropost)
    Comment.find(params[:id]).destroy
  end

  private
  # ストロングパラメータ
    def comment_params
      params.require(:comment).permit(:content, :micropost_id)
    end
end