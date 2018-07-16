class WorldcupController < ApplicationController
  def index
    render json: WorldCup.matches_on(Date.parse(params[:date]))
  end
end
