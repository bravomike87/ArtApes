class ArtworksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index

    if params[:search].present?
      sql_query = "description ILIKE :query OR title ILIKE :query OR tagline ILIKE :query OR kind ILIKE :query"
      @artworks_filter = policy_scope(Artwork).where(sql_query, query: "%#{params[:search]}%")
    elsif params[:search_location].present?
      @location = params[:search_location]

      # @artworks_filter = policy_scope(Artwork).order(created_at: :desc)
      if params[:search_location_radius] != ""
        radius = params[:search_location_radius]
      else
        radius = 5
      end
      @profiles_by_location = policy_scope(Profile).near("%#{params[:search_location]}%", radius)

      @artworks_filter = []
      @profiles_by_location.each do |profile|
        profile.user.artworks.each { |e| @artworks_filter << e }

      end

    else
      @artworks_filter = policy_scope(Artwork).order(created_at: :desc)
    end

    #### to display the markers on the map for thoses with address
    @artworks_filter_with_gps = @artworks_filter.reject { |x| x.user.profile.latitude.nil? }

    @markers = @artworks_filter_with_gps.map do |artwork|
      {
        lat: artwork.user.profile.latitude,
        lng: artwork.user.profile.longitude,
        # to make that work : create a _infowindow partial into views/artworks !!!
        infoWindow: render_to_string(partial: "infowindow", locals: { artwork: artwork })
      }
    end
    ### end markers

  end

  def show
    @artwork = Artwork.find(params[:id])
    authorize @artwork

    if @artwork.user.profile.latitude
      @markers = [{
          lat: @artwork.user.profile.latitude,
          lng: @artwork.user.profile.longitude,
          # to make that work : create a _infowindow partial into views/artworks !!!
          infoWindow: render_to_string(partial: "infowindow_show", locals: { artwork: @artwork })
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
