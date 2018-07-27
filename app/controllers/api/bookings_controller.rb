module Api
  class BookingsController < ApplicationController
    before_action :authenticated,
                  only: [:index, :show, :update, :destroy]
    before_action :authorized, only: [:update, :show, :destroy]

    def index
      user = User.find_by(token: request.headers['Authorization'])
      render json: Booking.where('user_id = ?', user.id)
    end

    def create
      user = User.find_by(token: request.headers['Authorization'])
      booking = Booking.new(booking_params.merge(user_id: user.id))

      save_and_render_booking(booking)
    end

    def show
      booking = Booking.find(params[:id])

      return unless authorize_user(booking, request.headers['Authorization'])

      render json: booking
    end

    def update
      booking = Booking.find(params[:id])

      return unless authorize_user(booking, request.headers['Authorization'])

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

    def authorize_user(booking, token)
      user = User.find_by(token: token)

      return true if booking.user_id == user.id
      render json: { errors: { token: ['is invalid'] } },
             status: :unauthorized
      false
    end

    def save_and_render_booking(booking)
      if booking.save
        render json: booking, status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def booking_params
      params.require(:booking).permit(:no_of_seats, :seat_price, :flight_id)
    end
  end
end
