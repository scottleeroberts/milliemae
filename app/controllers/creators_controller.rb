class CreatorsController < ApplicationController
  def show
    actor = Creators::Show.call(username: params[:id])
    @creator = actor.creator
    @projects = actor.projects
  end
end
