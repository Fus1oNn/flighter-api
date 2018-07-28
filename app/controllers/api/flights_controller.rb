module Api
  class FlightsController < ApplicationController
    before_action :authenticated

    def index
      render json: Flight.all
    end

    def create
      flight = Flight.new(flight_params)

      if flight.save
        render json: flight, status: :created
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    def show
      render json: Flight.find(params[:id])
    end

    def update
      flight = Flight.find(params[:id])

      if flight.update(flight_params)
        render json: flight
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    def destroy
      Flight.find(params[:id]).destroy!
      head :no_content
    end

    private

    def flight_params
      params.require(:flight).permit(:name, :no_of_seats, :base_price,
                                     :flys_at, :lands_at, :company_id)
    end
  end
end
