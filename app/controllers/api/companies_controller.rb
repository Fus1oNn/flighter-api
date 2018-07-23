module Api
  class CompaniesController < ApplicationController
    def index
      render json: Company.all
    end

    def create
      company = Company.new(company_params)

      if company.save
        render json: company, status: :created
      else
        render json: company.errors, status: :unprocessable_entity
      end
    end

    def show
      company = Company.find_by(id: params[:id])
      if company.nil?
        render json: 'Company not found', status: :not_found
      else
        render json: company
      end
    end

    def update
      company = Company.find(params[:id])

      if company.update(company_params)
        company.save
        render json: company
      else
        render json: company.errors, status: :bad_request
      end
    end

    def destroy
      company = Company.find(params[:id])

      if company.destroy
        render json: company, status: :no_content
      else
        render json: company.errors, status: :bad_request
      end
    end

    private

    def company_params
      params.require(:company).permit(:name)
    end
  end
end
