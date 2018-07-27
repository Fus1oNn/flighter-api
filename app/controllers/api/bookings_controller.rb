module Api
  class BookingsController < ApplicationController
    before_action :authenticated,
                  only: [:index, :create, :show, :update, :destroy]
    before_action :authorized, only: [:update, :show, :destroy]

    def index
      render json: Booking.all
    end

    def create
      booking = Booking.new(booking_params)
      user = User.find_by(token: request.headers['Authorization'])

      unless booking.user_id == user.id
        render json: { errors: { token: ['is invalid'] } },
               status: :unauthorized && return
      end

      save_and_render_booking(booking)
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

    attr_accessor :token, :user

    def authenticated
      token = request.headers['Authorization']
      user = User.find_by(token: token)

      if token && user
      else
        render json: { errors: { token: ['is invalid'] } },
               status: :unauthorized
      end
    end

    def authorized
      token = request.headers['Authorization']
      user = User.find_by(token: token)
      booking = Booking.find(params[:id])
      if user.id == booking.user_id
      else
        render json: { errors: { resource: ['is forbidden'] } },
               status: :forbidden
      end
    end

    def save_and_render_booking(booking)
      if booking.save
        render json: booking, status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def booking_params
      params.require(:booking).permit(:no_of_seats, :seat_price,
                                      :user_id, :flight_id)
    end
  end
end
