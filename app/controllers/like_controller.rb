class LikesController < ApplicationController
  before_action :logged_in_user

  # POST /favorites/:micropost_id/create
  def create
    @micropost = Micropost.find(params[:micropost_id])
    current_user.like(@micropost)
    respond_to do |format|
      format.html { redirect_to request.referrer }
      format.js
    end
  end

  # DELETE /favorites/:micropost_id/destroy
  def destroy
    @micropost = Micropost.find(params[:micropost_id])
    current_user.like.find_by(micropost_id: @micropost.id).destroy
    respond_to do |format|
      format.html { redirect_to request.referrer }
      format.js
    end
  end
  
end