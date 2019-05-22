class ArtworksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    # @artworks = policy_scope(Artwork).order(created_at: :desc)
    @artworks_filter = policy_scope(Artwork).where("description like ?", "%#{params[:search]}%")


  end

  def show
    @artwork = Artwork.find(params[:id])
    authorize @artwork

    if @artwork.user.profile.latitude
      @markers = [{
          lat: @artwork.user.profile.latitude,
          lng: @artwork.user.profile.longitude
        }]
    end

  end

  def new
    @artwork = Artwork.new
    authorize @artwork
  end

  def create
    @artwork = Artwork.new(artwork_params)
    @artwork.user = current_user
    authorize @artwork
    if @artwork.save
      redirect_to artwork_path(@artwork)
    else
      render :new
    end
  end

  def edit
    @artwork = Artwork.find(params[:id])
    authorize @artwork
  end

  def update
    @artwork = Artwork.find(params[:id])
    authorize @artwork
    if @artwork.update(artwork_params)
      redirect_to artwork_path(@artwork)
    else
      render :edit
    end
  end

  def destroy
    @artwork = Artwork.find(params[:id])
    authorize @artwork
    @artwork.destroy
    redirect_to profile_path(current_user)
  end

  private

  def artwork_params
    params.require(:artwork).permit(:title, :description, :image, :kind, :price, :width, :height, :tagline)
  end
end
