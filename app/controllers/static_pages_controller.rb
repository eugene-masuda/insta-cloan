class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @user = current_user
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      if params[:q]
        @feed_items = Micropost.search_by_keyword(params[:q])
                        .paginate(page: params[:page])
      else
        @feed_items = current_user.feed.paginate(page: params[:page])
      end
    end
  end

  
end
