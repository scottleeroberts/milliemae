class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_creator

  def create
    if @creator == current_user
      return redirect_to creator_path(@creator), alert: "You cannot follow yourself."
    end

    current_user.follows.find_or_create_by!(following: @creator)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to creator_path(@creator) }
    end
  end

  def destroy
    current_user.follows.find_by(following: @creator)&.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to creator_path(@creator) }
    end
  end

  private

  def set_creator
    @creator = User.creator.find_by!(username: params[:creator_id])
  end
end
