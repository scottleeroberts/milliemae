class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_creator

  def create
    actor = Follows::Create.result(follower: current_user, following: @creator)
    return redirect_to creator_path(@creator), alert: actor.error if actor.failure?

    @creator.reload
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to creator_path(@creator) }
    end
  end

  def destroy
    Follows::Destroy.call(follower: current_user, following: @creator)
    @creator.reload
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
