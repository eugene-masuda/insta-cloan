class PasswordResetsController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  
  def edit
    @user = User.find(params[:id]) 
  end
  
  def update
    @user = User.find(params[:id]) 
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
    elsif correct_password_now?(@user) && correspond_new_password?
      @user.update(user_params_update)
      flash.now[:success] = "password was change！"
    else
      flash.now[:danger] = "現在のパスワード、あるいは新しいパスワードが異なっています。"
    end
    render 'edit' # Successの場合もFailureの場合もこの処理を行う
  end
  
  private
  
    
    def correct_password_now?(user)
      user.authenticate(params[:user][:password_now])
    end
    
  
    def correspond_new_password?
      params[:user][:password] == params[:user][:password_confirmation]
    end
  
   
    def user_params_update
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    # beforeアクション


    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end

    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
