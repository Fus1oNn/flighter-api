module Api
  class UsersController < ApplicationController
    before_action :authenticated, only: [:index, :show, :update, :destroy]
    before_action :authorized, only: [:update, :show, :destroy]

    def index
      render json: User.all
    end

    def create
      user = User.new(user_params)

      if user.save
        render json: user, status: :created
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    def show
      render json: User.find(params[:id])
    end

    def update
      user = User.find(params[:id])

      if user.update(user_params)
        render json: user
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    def destroy
      User.find(params[:id]).destroy!
      head :no_content
    end

    private

    attr_accessor :token, :user

    def authenticated
      token = request.headers['Authorization']
      user = User.find_by!(token: token)

      if token && user
      else
        render json: { errors: { token: ['is invalid'] } },
               status: :unauthorized
      end
    end

    def authorized
      authenticated_user = User.find_by(token: request.headers['Authorization'])
      if authenticated_user.id == params[:id].to_i
      else
        render json: { errors: { resource: ['is forbidden'] } },
               status: :forbidden
      end
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password)
    end
  end
end
