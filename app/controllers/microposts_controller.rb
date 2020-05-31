class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:show, :new, :create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def show
    @micropost = Micropost.find_by(id: params[:id])
    @user = @micropost.user
    @comment = @micropost.comments.build(user_id: current_user.id)
    @comments = @micropost.comments.all
  end
  
  def new
    @micropost = current_user.microposts.build if logged_in?
  end
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost = Micropost.find(params[:id])
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end
  
   private

  def micropost_params
      params.require(:micropost).permit(:content)
  end
  
  def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
  end
end
