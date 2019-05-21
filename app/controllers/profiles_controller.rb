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
    @profile = Profile.find(params[:id])
    if @profile.update(profile_params)
      redirect_to profile_path(@profile)
    else
      render :edit
    end
  end

  def destroy
    @profile = Profile.find(params[:id])
    @user = @profile.user
    @profile.destroy
    @user.destroy
  end

  private

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :address, :description, :avatar)
  end

end
