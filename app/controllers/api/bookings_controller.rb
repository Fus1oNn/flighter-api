module Api
  class BookingsController < ApplicationController
    def index
      render json: Booking.all
    end

    def create
      booking = Booking.new(booking_params)

      if booking.save
        render json: booking, status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def show
      render json: Booking.find(params[:id])
    end

    def update
      booking = Booking.find(params[:id])

      if booking.update(booking_params)
        render json: booking
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def destroy
      Booking.find(params[:id]).destroy!
      head :no_content
    end

    private

    def booking_params
      params.require(:booking).permit(:no_of_seats, :seat_price,
                                      :user_id, :flight_id)
    end
  end
end
