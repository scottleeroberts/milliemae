class CreatorsController < ApplicationController
  def show
    actor = Creators::ProfileLoader.call(username: params[:id])
    @creator = actor.creator
    @projects = actor.projects
  end
end
