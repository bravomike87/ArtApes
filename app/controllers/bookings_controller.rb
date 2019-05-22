class BookingsController < ApplicationController
  def create
    # to do : catch the POST request with artwork_id and create a booking
    @booking = Booking.new(artwork_id: params[:artwork_id], user_id: current_user.id)
    @artwork = Artwork.find(params[:artwork_id])
    authorize @booking
    if @booking.save
      redirect_to artworks_path
    else
      render :new
    end
  end

  # def index
  #   @bookings = Booking.where("user_id == ?", "#{current_user}")
  # end

  def destroy

  end
end



# policy_scope(Artwork).where("description like ?", "%#{params[:search]}%")
