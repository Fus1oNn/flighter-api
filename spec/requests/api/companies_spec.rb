RSpec.describe 'Companies API', type: :request do
  include TestHelpers::JsonResponse

  let(:company) { FactoryBot.create(:company) }

  describe 'GET /companies' do
    context 'when a request is sent' do
      it 'returns a list of companies' do
        company

        get '/api/companies'

        expect(json_body['companies'].length).to eq(1)
      end
    end
  end

  describe 'GET /companies/:id' do
    context 'when company exists' do
      it 'returns the company in json' do
        get "/api/companies/#{company.id}"

        expect(json_body['company'])
          .to include('name' => company.name)
      end
    end

    context "when company doesn't exist" do
      it 'returns 404 not found' do
        get '/api/companies/1'
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /companies' do
    context 'when params are valid' do
      it 'creates a company' do
        post '/api/companies',
             params: { company: { name: 'Croatia Airlines' } }
        expect(json_body['company'])
          .to include('name' => 'Croatia Airlines')
      end
    end

    context 'when params are invalid' do
      it 'returns 400 bad request' do
        post '/api/companies', params: { company: { name: '' } }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns errors' do
        post '/api/companies', params: { company: { name: '' } }

        expect(json_body['errors']).to include('name')
      end
    end
  end

  describe 'PUT /companies/:id' do
    context 'when params are okay' do
      it 'updates company' do
        put "/api/companies/#{company.id}", params: { company:
                                                      { name: 'Empires' } }

        expect(json_body['company']).to include('name' => 'Empires')
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
      it 'returns 204 no content' do
        delete "/api/companies/#{company.id}"

        expect(response).to have_http_status(:no_content)
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
