class BookingsController < ApplicationController

  def new
    #@booking = Booking.new(artwork_id: params[:artwork_id], user_id: current_user.id)
    @booking = Booking.new
    @artwork = Artwork.find(params[:artwork_id])
    @booking.artwork = @artwork
    authorize @booking
  end

  def create
    # to do : catch the POST request with artwork_id and create a booking
    @booking = Booking.new(status: "Action needed", user_id: current_user.id, start_date: params[:booking][:start_date], end_date: params[:booking][:end_date])
    @artwork = Artwork.find(params[:artwork_id])
    @booking.artwork = @artwork
    authorize @booking
    if @booking.save
      redirect_to profile_bookings_path(@current_user)
    else
      render :new
    end
  end

  # def index
  #   @bookings = Booking.where("user_id == ?", "#{current_user}")
  # end
  def confirm
    @booking = Booking.find(params[:id])
    authorize @booking
    @booking.status = "confirmed"
    @booking.save
    redirect_to profile_requests_path(current_user.profile)
  end

  def reject
    @booking = Booking.find(params[:id])
    authorize @booking
    @booking.status = "rejected"
    @booking.save
    redirect_to profile_requests_path(current_user.profile)
  end




  def destroy
    @booking = Booking.find(params[:id])
    authorize @booking
    @booking.destroy
    redirect_to profile_path(current_user)
  end
end

# policy_scope(Artwork).where("description like ?", "%#{params[:search]}%")
