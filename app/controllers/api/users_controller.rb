module Api
  class UsersController < ApplicationController
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

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email)
    end
  end
end
