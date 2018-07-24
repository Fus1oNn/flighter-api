RSpec.describe 'Flights API', type: :request do
  include TestHelpers::JsonResponse

  let(:flight) { FactoryBot.create(:flight) }
  let(:company) { FactoryBot.create(:company) }

  describe 'GET /flights' do
    context 'when a request is sent' do
      before { flight }

      it 'returns a list of flights' do
        get '/api/flights'

        expect(json_body['flights'].length).to eq(1)
      end

      it 'returns 200 ok' do
        get '/api/flights'

        expect(response).to have_http_status(:ok)
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

      it 'returns 200 ok' do
        get "/api/flights/#{flight.id}"

        expect(response).to have_http_status(:ok)
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
      before do
        post '/api/flights', params: { flight:
                                     { name: 'Dubai',
                                       flys_at: 2.days.from_now,
                                       lands_at: 3.days.from_now,
                                       no_of_seats: 100, base_price: 10,
                                       company_id: company.id } }
      end

      it 'creates a flight' do
        expect(json_body['flight']).to include('name' => 'Dubai')
      end

      it 'returns 201 created' do
        expect(response).to have_http_status(:created)
      end

      it 'really creates flight in DB' do
        count_before = Flight.all.count

        post '/api/flights', params: { flight:
                                     { name: 'Hawaii',
                                       flys_at: 2.days.from_now,
                                       lands_at: 3.days.from_now,
                                       no_of_seats: 100, base_price: 10,
                                       company_id: company.id } }

        count_after = Flight.all.count

        expect(count_after).to eq(count_before + 1)
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
      before do
        put "/api/flights/#{flight.id}", params: { flight: { name: 'Dubai' } }
      end

      it 'updates flight' do
        expect(json_body['flight']).to include('name' => 'Dubai')
      end

      it 'returns 200 ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'really updated flight in DB' do
        flight_after = Flight.find(flight.id)

        expect(flight_after.name).to eq('Dubai')
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

      it 'really deletes flight from DB' do
        flight

        count_before = Flight.all.count

        delete "/api/flights/#{flight.id}"

        count_after = Flight.all.count

        expect(count_after).to eq(count_before - 1)
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
