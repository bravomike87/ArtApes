class ProfilesController < ApplicationController

  def show
    @profile = Profile.find(params[:id])
  end

  def new
  end

  def create
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def update
    @profile
  end

  def destroy
  end
end
