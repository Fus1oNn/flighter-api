class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :server_error

  def server_error(error)
    render json: { errors: error }, status: :internal_server_error
  end

  def not_found
    render json: { errors: { resource: ['does not exist'] } },
           status: :not_found
  end

  def authenticated
    token = request.headers['Authorization']
    user = User.find_by(token: token)

    return if token && user

    render json: { errors: { token: ['is invalid'] } },
           status: :unauthorized
  end
end
