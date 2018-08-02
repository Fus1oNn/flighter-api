module Api
  class BookingsController < ApplicationController
    before_action :authenticated
    before_action :authorized, only: [:update, :show, :destroy]

    def index
      user = User.find_by(token: request.headers['Authorization'])
      render json: Booking.where(user: user)
    end

    def create
      user = User.find_by(token: request.headers['Authorization'])
      booking = Booking.new(booking_params.merge(user_id: user.id))

      if booking.save
        render json: booking, status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def show
      booking = Booking.find(params[:id])

      render json: booking
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

    def authorized
      user = User.find_by(token: request.headers['Authorization'])
      booking = Booking.find(params[:id])

      return if user.id == booking.user_id
      render json: { errors: { resource: ['is forbidden'] } },
             status: :forbidden
    end

    def booking_params
      params.require(:booking).permit(:no_of_seats, :seat_price, :flight_id)
    end
  end
end
