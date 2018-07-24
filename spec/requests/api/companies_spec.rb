RSpec.describe 'Companies API', type: :request do
  include TestHelpers::JsonResponse

  let(:company) { FactoryBot.create(:company) }

  describe 'GET /companies' do
    context 'when a request is sent' do
      before { company }

      it 'returns a list of companies' do
        get '/api/companies'

        expect(json_body['companies'].length).to eq(1)
      end

      it 'returns 200 ok' do
        get '/api/companies'

        expect(response).to have_http_status(:ok)
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

      it 'returns 200 ok' do
        get "/api/companies/#{company.id}"

        expect(response).to have_http_status(:ok)
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
      before do
        post '/api/companies',
             params: { company: { name: 'Croatia Airlines' } }
      end

      it 'creates a company' do
        expect(json_body['company']).to include('name' => 'Croatia Airlines')
      end

      it 'returns 201 created' do
        expect(response).to have_http_status(:created)
      end

      it 'really creates company in DB' do
        count_before = Company.all.count

        post '/api/companies',
             params: { company: { name: 'Emirates' } }

        count_after = Company.all.count

        expect(count_after).to eq(count_before + 1)
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
      before do
        put "/api/companies/#{company.id}", params: { company:
                                                      { name: 'Germanwings' } }
      end

      it 'updates company' do
        expect(json_body['company']).to include('name' => 'Germanwings')
      end

      it 'returns 200 ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'really updated company in DB' do
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
      it 'returns 204 no content' do
        delete "/api/companies/#{company.id}"

        expect(response).to have_http_status(:no_content)
      end

      it 'really deletes company from DB' do
        company

        count_before = Company.all.count

        delete "/api/companies/#{company.id}"

        count_after = Company.all.count

        expect(count_after).to eq(count_before - 1)
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
