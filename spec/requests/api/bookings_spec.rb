RSpec.describe 'Bookings API', type: :request do
  include TestHelpers::JsonResponse
  let(:user) { FactoryBot.create(:user) }
  let(:flight) { FactoryBot.create(:flight) }
  let(:booking) { FactoryBot.create(:booking) }

  describe 'GET /bookings' do
    context 'when a request is sent' do
      it 'returns a list of bookings' do
        booking

        get '/api/bookings'

        expect(json_body['bookings'].length).to eq(1)
      end
    end
  end

  describe 'GET /bookings/:id' do
    context 'when booking exists' do
      it 'returns the booking in json' do
        get "/api/bookings/#{booking.id}"

        expect(json_body['booking'])
          .to include('seat_price' => booking.seat_price)
      end
    end

    context "when booking doesn't exist" do
      it 'returns 404 not found' do
        get '/api/bookings/1'
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /bookings' do
    context 'when params are valid' do
      it 'creates a booking' do
        post '/api/bookings',
             params: { booking: { seat_price: 3, no_of_seats: 5,
                                  user_id: user.id,
                                  flight_id: flight.id } }
        expect(json_body['booking'])
          .to include('seat_price' => 3)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 bad request' do
        post '/api/bookings', params: { booking: { seat_price: 3 } }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns errors' do
        post '/api/bookings', params: { booking: { seat_price: 3 } }

        expect(json_body['errors']).to include('no_of_seats')
      end
    end
  end

  describe 'PUT /bookings/:id' do
    context 'when params are okay' do
      it 'updates booking' do
        put "/api/bookings/#{booking.id}", params: { booking:
                                                   { seat_price: 3 } }

        expect(json_body['booking']).to include('seat_price' => 3)
      end
    end

    context 'when params not okay' do
      it 'returns 400 bad request' do
        put "/api/bookings/#{booking.id}", params: { booking:
                                                   { seat_price: 0 } }

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'DELETE /bookings/:id' do
    context 'when booking exists' do
      it 'returns 204 no content' do
        delete "/api/bookings/#{booking.id}"

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when booking does not exist' do
      it 'returns 404 not found' do
        delete '/api/bookings/1'

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
