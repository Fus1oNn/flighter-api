module Api
  class FlightsController < ApplicationController
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
      flight = Flight.find(params[:id])

      render json: flight
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
      flight = Flight.find(params[:id])

      if flight.destroy
        render json: flight, status: :no_content
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    private

    def flight_params
      params.require(:flight).permit(:name, :no_of_seats, :base_price,
                                     :flys_at, :lands_at, :company_id)
    end
  end
end
