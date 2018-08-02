RSpec.describe 'Flights API', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:auth) { { Authorization: user.token } }

  include TestHelpers::JsonResponse

  describe 'GET /api/flights' do
    let(:flight) { FactoryBot.create(:flight) }

    context 'when authenticated and  a request is sent' do
      before { flight }

      it 'returns a list of flights' do
        get '/api/flights', headers: auth

        expect(json_body['flights'].length).to eq(1)
      end

      it 'returns 200 ok' do
        get '/api/flights', headers: auth

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when not authenticated' do
      it 'returns an error message' do
        get '/api/flights'

        expect(json_body['errors']).to include('token')
      end

      it 'returns status 401 unauthorized' do
        get '/api/flights'

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/flights/:id' do
    context 'when authenticated and flight exists' do
      let(:flight) { FactoryBot.create(:flight) }

      it 'returns the flight in json' do
        get "/api/flights/#{flight.id}", headers: auth

        expect(json_body['flight'])
          .to include('name' => flight.name)
      end

      it 'returns 200 ok' do
        get "/api/flights/#{flight.id}", headers: auth

        expect(response).to have_http_status(:ok)
      end
    end

    context "when authenticated and flight doesn't exist" do
      it 'returns 404 not found' do
        get '/api/flights/1', headers: auth

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when not authenticated' do
      let(:flight) { FactoryBot.create(:flight) }

      it 'returns an error message' do
        get "/api/flights/#{flight.id}"

        expect(json_body['errors']).to include('token')
      end

      it 'returns status 401 unauthorized' do
        get "/api/flights/#{flight.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/flights' do
    context 'when authenticated and params are valid' do
      let(:company) { FactoryBot.create(:company) }
      let(:flight_params) do
        { flight: { name: 'Dubai',
                    flys_at: 2.days.from_now,
                    lands_at: 3.days.from_now,
                    no_of_seats: 100, base_price: 10,
                    company_id: company.id } }
      end

      it 'creates a flight' do
        post '/api/flights', params: flight_params, headers: auth

        expect(json_body['flight']).to include('name' => 'Dubai')
      end

      it 'returns 201 created' do
        post '/api/flights', params: flight_params, headers: auth

        expect(response).to have_http_status(:created)
      end

      it 'really creates flight in DB' do
        expect do
          post '/api/flights', params: flight_params, headers: auth
        end.to change(Flight, :count).by(1)
      end
    end

    context 'when authenticated and params are invalid' do
      it 'returns 400 bad request' do
        post '/api/flights', params: { flight: { name: '' } }, headers: auth

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns errors' do
        post '/api/flights', params: { flight: { name: '' } }, headers: auth

        expect(json_body['errors']).to include('name')
      end
    end

    context 'when not authenticated' do
      it 'returns an error message' do
        post '/api/flights'

        expect(json_body['errors']).to include('token')
      end

      it 'returns status 401 unauthorized' do
        post '/api/flights'

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /api/flights/:id' do
    let(:flight) { FactoryBot.create(:flight) }

    context 'when authenticated and params are okay' do
      let(:flight_params) { { flight: { name: 'Dubai' } } }

      it 'updates flight' do
        put "/api/flights/#{flight.id}", params: flight_params, headers: auth

        expect(json_body['flight']).to include('name' => 'Dubai')
      end

      it 'returns 200 ok' do
        put "/api/flights/#{flight.id}", params: flight_params, headers: auth

        expect(response).to have_http_status(:ok)
      end

      it 'really updated flight in DB' do
        put "/api/flights/#{flight.id}", params: flight_params, headers: auth

        expect(flight.reload.name).to eq('Dubai')
      end
    end

    context 'when authenticated and  params not okay' do
      it 'returns 400 bad request' do
        put "/api/flights/#{flight.id}", params: { flight: { name: '' } },
                                         headers: auth

        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when not authenticated' do
      it 'returns an error message' do
        put "/api/flights/#{flight.id}"

        expect(json_body['errors']).to include('token')
      end

      it 'returns status 401 unauthorized' do
        put "/api/flights/#{flight.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/flights/:id' do
    context 'when authenticated and flight exists' do
      let(:flight) { FactoryBot.create(:flight) }

      it 'returns 204 no content' do
        delete "/api/flights/#{flight.id}", headers: auth

        expect(response).to have_http_status(:no_content)
      end

      it 'really deletes flight from DB' do
        flight

        expect do
          delete "/api/flights/#{flight.id}", headers: auth
        end.to change(Flight, :count).by(-1)
      end
    end

    context 'when authenticated and flight does not exist' do
      it 'returns 404 not found' do
        delete '/api/flights/1', headers: auth

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when not authenticated' do
      let(:flight) { FactoryBot.create(:flight) }

      it 'returns an error message' do
        delete "/api/flights/#{flight.id}"

        expect(json_body['errors']).to include('token')
      end

      it 'returns status 401 unauthorized' do
        delete "/api/flights/#{flight.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
