RSpec.describe 'Flights API', type: :request do
  include TestHelpers::JsonResponse

  let(:flight) { FactoryBot.create(:flight) }
  let(:company) { FactoryBot.create(:company) }

  describe 'GET /flights' do
    context 'when a request is sent' do
      it 'returns a list of flights' do
        flight

        get '/api/flights'

        expect(json_body['flights'].length).to eq(1)
      end
    end
  end

  describe 'GET /flights/:id' do
    context 'when flight exists' do
      it 'returns the flight in json' do
        get "/api/flights/#{flight.id}"

        expect(json_body['flight'])
          .to include('name' => flight.name)
      end
    end

    context "when flight doesn't exist" do
      it 'returns 404 not found' do
        get '/api/flights/1'
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /flights' do
    context 'when params are valid' do
      it 'creates a flight' do
        post '/api/flights', params: { flight:
                                     { name: 'Dubai',
                                       flys_at: 2.days.from_now,
                                       lands_at: 3.days.from_now,
                                       no_of_seats: 100, base_price: 10,
                                       company_id: company.id } }
        expect(json_body['flight']).to include('name' => 'Dubai')
      end
    end

    context 'when params are invalid' do
      it 'returns 400 bad request' do
        post '/api/flights', params: { flight: { name: '' } }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns errors' do
        post '/api/flights', params: { flight: { name: '' } }

        expect(json_body['errors']).to include('name')
      end
    end
  end

  describe 'PUT /flights/:id' do
    context 'when params are okay' do
      it 'updates flight' do
        put "/api/flights/#{flight.id}", params: { flight: { name: 'Dubai' } }

        expect(json_body['flight']).to include('name' => 'Dubai')
      end
    end

    context 'when params not okay' do
      it 'returns 400 bad request' do
        put "/api/flights/#{flight.id}", params: { flight: { name: '' } }

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'DELETE /flights/:id' do
    context 'when flight exists' do
      it 'returns 204 no content' do
        delete "/api/flights/#{flight.id}"

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when flight does not exist' do
      it 'returns 404 not found' do
        delete '/api/flights/1'

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
