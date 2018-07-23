class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::NotFoundError, with: :not_found

  def not_found
    render json: { errors: { resource: ['does not exist'] } },
           status: :not_found
  end
end
