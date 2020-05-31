class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers, :likes]
  before_action :correct_user,   only: [:edit, :update]
 
  def index
    @users = User.paginate(page: params[:page])
  end
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def new
     @user = User.new
  end
  
  def create
   @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Instagram!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params_update)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    # ユーザー一覧ページの「削除」リンクがクリックされた場合
    if request.referrer == users_url
      if current_user.admin?
        @user.destroy
        flash[:success] = "ユーザーの削除に成功しました"
        redirect_to users_url
      else
        redirect_to root_url
      end
    # プロフィール編集ページの「アカウントを削除する」リンクがクリックされた場合
    elsif request.referrer == edit_user_url
      if current_user?(@user)
        @user.destroy
        flash[:success] = "アカウントを削除しました"
        redirect_to root_url
      end
    else
      redirect_to root_url
    end
  end
  
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def likes
    @title = "Likes"
    @user  = User.find(params[:id])
    @microposts = @user.likes.paginate(page: params[:page])
    render 'show_like'
  end
  
  def facebook_login
    @user = User.from_omniauth(request.env["omniauth.auth"])
    result = @user.save(context: :facebook_login)
    if result
      log_in @user
      redirect_to @user
    else
      redirect_to auth_failure_path
    end
  end

  # FB認証（失敗時）
  def auth_failure 
    @user = User.new
    render '任意のアクション'
  end
  
  private

  def user_params
      params.require(:user).permit(:full_name, :user_name, :email, 
                                   :password,  :password_confirmation)
  end
  
  def user_params_update
      params.require(:user).permit(:full_name, :user_name, :website, :introduction,
                                   :email, :phone_number, :sex)
  end
  
  # beforeアクション

  
  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  
  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
