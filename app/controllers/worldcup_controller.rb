class WorldcupController < ApplicationController
  def index
    if params[:date].present?
      render json: WorldCup.matches_on(Date.parse(params[:date]))
    else
      render json: WorldCup.matches
    end
  end
end
