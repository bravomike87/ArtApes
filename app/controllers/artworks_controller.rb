class ArtworksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    # why did we need that line ?? So I comment it, to be deleted (Agathe)
    # @artworks = policy_scope(Artwork).order(created_at: :desc)

    if params[:search].present?
      sql_query = "description ILIKE :query OR title ILIKE :query OR tagline ILIKE :query OR kind ILIKE :query"
      @artworks_filter = policy_scope(Artwork).where(sql_query, query: "%#{params[:search]}%")
    else
      @artworks_filter = policy_scope(Artwork).order(created_at: :desc)
    end

    @artworks_filter_with_gps = @artworks_filter.reject { |x| x.user.profile.latitude.nil? }

    @markers = @artworks_filter_with_gps.map do |artwork|
      {
        lat: artwork.user.profile.latitude,
        lng: artwork.user.profile.longitude,
        # this is not working for I don't know which reason !
        # infoWindow: render_to_string(partial: "infowindow", locals: { artwork: artwork })
      }
    end
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
