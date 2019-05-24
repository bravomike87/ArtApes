class ProfilesController < ApplicationController
  def show
    @profile = current_user.profile
    authorize @profile
  end

  def new
  end

  def create
  end

  def edit
    @profile = current_user.profile
    session[:return_to] ||= request.referer
    authorize @profile
  end

  def update
    @profile = current_user.profile
    authorize @profile
    if @profile.update(profile_params)
      if (session[:return_to] == "http://localhost:3000/") || (session[:return_to] == "https://mona-leasing.herokuapp.com")
        redirect_to new_artwork_path
      else
        redirect_to session.delete(:return_to)
      end
    else
      render :edit
    end
  end

  def destroy
  end

  def artworks
    @profile = current_user.profile
    @artworks = policy_scope(Artwork.all) #policy_scope(current_user.artworks)
    authorize @profile
  end

  def requests
    @profile = current_user.profile
    @artworks = policy_scope(Artwork.all) #policy_scope(current_user.artworks)
    authorize @profile
  end

  def bookings
    @profile = current_user.profile
    @artworks = policy_scope(Artwork.all) #policy_scope(current_user.artworks)
    authorize @profile
  end

  private

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :address, :description, :avatar)
  end

end
