module Api
  class CompaniesController < ApplicationController
    before_action :authenticated, only: [:index, :create, :show,
                                         :update, :destroy]

    def index
      render json: Company.all
    end

    def create
      company = Company.new(company_params)

      if company.save
        render json: company, status: :created
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    def show
      render json: Company.find(params[:id])
    end

    def update
      company = Company.find(params[:id])

      if company.update(company_params)
        render json: company
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    def destroy
      Company.find(params[:id]).destroy!
      head :no_content
    end

    private

    def authenticated
      token = request.headers['Authorization']
      user = User.find_by(token: token)

      if token && user
      else
        render json: { errors: { token: ['is invalid'] } },
               status: :unauthorized
      end
    end

    def company_params
      params.require(:company).permit(:name)
    end
  end
end
