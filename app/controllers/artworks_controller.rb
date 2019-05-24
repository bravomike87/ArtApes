class ArtworksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index

    if params[:search].present? && !params[:search_location].present?
      # first case : only the search by keyword
      @artworks_filter = search_by_keyword(params[:search])

    elsif !params[:search].present? && params[:search_location].present?
      # second case : only by location
      @artworks_filter = search_by_location(params[:search_location], params[:search_location_radius])

    elsif params[:search].present? && params[:search_location].present?
      # third case : both location and keyword
      @artworks_filter_by_keyword = search_by_keyword(params[:search])
      @artworks_filter_by_location = search_by_location(params[:search_location], params[:search_location_radius])

      @artworks_filter = @artworks_filter_by_keyword & @artworks_filter_by_location

    else
      # no search criterias : render everything !
      @artworks_filter = grab_all
    end

    if @artworks_filter == []
      @search_result_success = false
      @artworks_filter = grab_all
    else
      @search_result_success = true
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

  def grab_all
    policy_scope(Artwork).order(created_at: :desc)
  end

  def search_by_keyword(keyword)
    sql_query = "description ILIKE :query OR title ILIKE :query OR tagline ILIKE :query OR kind ILIKE :query"
    return policy_scope(Artwork).where(sql_query, query: "%#{keyword}%")
  end

  def search_by_location(location, radius)
    radius = 5 if radius == ""

    profiles_by_location = policy_scope(Profile).near("%#{location}%", radius)

    artworks_filter = []
    profiles_by_location.each do |profile|
      profile.user.artworks.each { |e| artworks_filter << e }
    end

    return artworks_filter
  end
end
