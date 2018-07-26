module Api
  class SessionsController < ApplicationController
    def create
      user = User.find_by!(email: session_params[:email])

      if user.authenticate(session_params[:password])
        render json: { session: { token: user.token, user: user } },
               status: :created
        # render json: user, serializer: SessionSerializer, status: :created
      else
        render json: { errors: { credentials: ['are invalid'] } },
               status: :bad_request
      end
    end

    def destroy
      token = request.headers['Authorization']
      user = User.find_by(token: token)

      if token && user
        user.regenerate_token
        head :no_content
      else
        render json: { errors: { token: ['is invalid'] } },
               status: :unauthorized
      end
    end

    private

    def session_params
      params.require(:session).permit(:email, :password)
    end
  end
end
