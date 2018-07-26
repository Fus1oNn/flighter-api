RSpec.describe 'Companies API', type: :request do
  let(:user) { FactoryBot.create(:user, token: 'abc123') }

  include TestHelpers::JsonResponse

  describe 'GET /companies' do
    let(:company) { FactoryBot.create(:company) }

    context 'when a request is sent' do
      before { company }

      it 'returns a list of companies' do
        get '/api/companies', headers: { Authorization: 'abc123' }

        expect(json_body['companies'].length).to eq(1)
      end

      it 'returns 200 ok' do
        get '/api/companies', headers: { Authorization: 'abc123' }

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /companies/:id' do
    context 'when company exists' do
      let(:company) { FactoryBot.create(:company) }

      it 'returns the company in json' do
        get "/api/companies/#{company.id}", headers: { Authorization: 'abc123' }

        expect(json_body['company'])
          .to include('name' => company.name)
      end

      it 'returns 200 ok' do
        get "/api/companies/#{company.id}", headers: { Authorization: 'abc123' }

        expect(response).to have_http_status(:ok)
      end
    end

    context "when company doesn't exist" do
      it 'returns 404 not found' do
        get '/api/companies/1', headers: { Authorization: 'abc123' }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /companies' do
    context 'when params are valid' do
      let(:company_params) { { company: { name: 'Croatia Airlines' } } }

      it 'creates a company' do
        post '/api/companies', params: company_params,
                               headers: { Authorization: 'abc123' }

        expect(json_body['company']).to include('name' => 'Croatia Airlines')
      end

      it 'returns 201 created' do
        post '/api/companies', params: company_params,
                               headers: { Authorization: 'abc123' }

        expect(response).to have_http_status(:created)
      end

      it 'really creates company in DB' do
        expect do
          post '/api/companies', params: company_params,
                                 headers: { Authorization: 'abc123' }
        end.to change(Company, :count).by(1)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 bad request' do
        post '/api/companies', params: { company: { name: '' } },
                               headers: { Authorization: 'abc123' }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns errors' do
        post '/api/companies', params: { company: { name: '' } },
                               headers: { Authorization: 'abc123' }

        expect(json_body['errors']).to include('name')
      end
    end
  end

  describe 'PUT /companies/:id' do
    let(:company) { FactoryBot.create(:company) }

    context 'when params are okay' do
      let(:company_params) { { company: { name: 'Germanwings' } } }

      before do
        put "/api/companies/#{company.id}", params: { company:
                                                      { name: 'Germanwings' } }
      end

      it 'updates company' do
        put "/api/companies/#{company.id}", params: company_params

        expect(json_body['company']).to include('name' => 'Germanwings')
      end

      it 'returns 200 ok' do
        put "/api/companies/#{company.id}", params: company_params

        expect(response).to have_http_status(:ok)
      end

      it 'really updated company in DB' do
        put "/api/companies/#{company.id}", params: company_params

        company_after = Company.find(company.id)

        expect(company_after.name).to eq('Germanwings')
      end
    end

    context 'when params not okay' do
      it 'returns 400 bad request' do
        put "/api/companies/#{company.id}", params: { company: { name: '' } }

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'DELETE /companies/:id' do
    context 'when company exists' do
      let(:company) { FactoryBot.create(:company) }

      it 'returns 204 no content' do
        delete "/api/companies/#{company.id}"

        expect(response).to have_http_status(:no_content)
      end

      it 'really deletes company from DB' do
        company

        expect do
          delete "/api/companies/#{company.id}"
        end.to change(Company, :count).by(-1)
      end
    end

    context 'when company does not exist' do
      it 'returns 404 not found' do
        delete '/api/companies/1'

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
