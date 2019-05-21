class ArtworksController < ApplicationController

  skip_before_action :authenticate_user!, only: :index

  def index
    @artworks_filter = Artwork.where("description like ?", "%#{params[:search]}%")
  end

  def show
    @artwork = Artwork.find(params[:id])
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
