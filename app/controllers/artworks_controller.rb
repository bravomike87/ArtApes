class ArtworksController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @artworks_filter = Artwork.where("description like ?", "%#{params[:search]}%")
  end

  def show
    @artwork = Artwork.find(params[:id])
    authorize @artwork
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
  end

  def destroy
  end

  private

  def artwork_params
    params.require(:artwork).permit(:title, :description, :image, :kind, :price, :width, :height, :tagline)
  end
end
