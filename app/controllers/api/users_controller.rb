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
        render json: user.errors, status: :bad_request
      end
    end

    def show
      user = User.find(params[:id])

      render json: user
    end

    def update
      user = User.find(params[:id])

      if user.update(user_params)
        user.save
        render json: user
      else
        render json: user.errors, status: :bad_request
      end
    end

    def destroy
      user = User.find(params[:id])

      if user.destroy
        render json: user, status: :no_content
      else
        render json: user.errors, status: :bad_request
      end
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email)
    end
  end
end
