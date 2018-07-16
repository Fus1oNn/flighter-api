class ApplicationController < ActionController::Base
  def world_cup
    render json: { message: 'Hi!' }
  end
end
