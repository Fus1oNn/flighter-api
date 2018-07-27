RSpec.describe 'Bookings API', type: :request do
  include TestHelpers::JsonResponse

  describe 'GET /bookings' do
    let(:booking) { FactoryBot.create(:booking) }
    let(:user) { User.find(booking.user_id) }
    let(:auth) { { Authorization: user.token } }

    context 'when a request is sent' do
      before { booking }

      it 'returns a list of bookings' do
        get '/api/bookings', headers: auth

        expect(json_body['bookings'].length).to eq(1)
      end

      it 'returns 200 ok' do
        get '/api/bookings', headers: auth

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /bookings/:id' do
    context 'when booking exists' do
      let(:booking) { FactoryBot.create(:booking) }
      let(:user) { User.find(booking.user_id) }
      let(:auth) { { Authorization: user.token } }

      it 'returns the booking in json' do
        get "/api/bookings/#{booking.id}", headers: auth

        expect(json_body['booking'])
          .to include('seat_price' => booking.seat_price)
      end

      it 'returns 200 ok' do
        get "/api/bookings/#{booking.id}", headers: auth

        expect(response).to have_http_status(:ok)
      end
    end

    context "when booking doesn't exist" do
      let(:user) { FactoryBot.create(:user) }
      let(:auth) { { Authorization: user.token } }

      it 'returns 404 not found' do
        get '/api/bookings/1', headers: auth
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /bookings' do
    context 'when params are valid' do
      let(:user) { FactoryBot.create(:user) }
      let(:auth) { { Authorization: user.token } }
      let(:flight) { FactoryBot.create(:flight) }
      let(:booking_params) do
        { booking: { seat_price: 3,
                     no_of_seats: 5,
                     user_id: user.id,
                     flight_id: flight.id } }
      end

      it 'creates a booking' do
        post '/api/bookings', params: booking_params, headers: auth

        expect(json_body['booking']).to include('seat_price' => 3)
      end

      it 'returns 201 created' do
        post '/api/bookings', params: booking_params, headers: auth

        expect(response).to have_http_status(:created)
      end

      it 'really creates booking in DB' do
        expect do
          post '/api/bookings', params: booking_params, headers: auth
        end.to change(Booking, :count).by(1)
      end
    end

    context 'when params are invalid' do
      let(:user) { FactoryBot.create(:user) }
      let(:auth) { { Authorization: user.token } }

      it 'returns 400 bad request' do
        post '/api/bookings', params: { booking: { user_id: user.id,
                                                   seat_price: 3 } },
                              headers: auth

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns errors' do
        post '/api/bookings', params: { booking: { user_id: user.id,
                                                   seat_price: 3 } },
                              headers: auth

        expect(json_body['errors']).to include('no_of_seats')
      end
    end
  end

  describe 'PUT /bookings/:id' do
    let(:booking) { FactoryBot.create(:booking) }
    let(:user) { User.find(booking.user_id) }
    let(:auth) { { Authorization: user.token } }

    context 'when params are okay' do
      let(:booking_params) { { booking: { seat_price: 3 } } }

      before do
        put "/api/bookings/#{booking.id}", params: { booking:
                                                   { seat_price: 3 } },
                                           headers: auth
      end

      it 'updates booking' do
        put "/api/bookings/#{booking.id}", params: booking_params, headers: auth

        expect(json_body['booking']).to include('seat_price' => 3)
      end

      it 'returns 200 ok' do
        put "/api/bookings/#{booking.id}", params: booking_params, headers: auth

        expect(response).to have_http_status(:ok)
      end

      it 'really updated booking in DB' do
        put "/api/bookings/#{booking.id}", params: booking_params, headers: auth

        booking_after = Booking.find(booking.id)

        expect(booking_after.seat_price).to eq(3)
      end
    end

    context 'when params not okay' do
      it 'returns 400 bad request' do
        put "/api/bookings/#{booking.id}", params: { booking:
                                                   { seat_price: 0 } },
                                           headers: auth

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'DELETE /bookings/:id' do
    context 'when booking exists' do
      let(:booking) { FactoryBot.create(:booking) }
      let(:user) { User.find(booking.user_id) }
      let(:auth) { { Authorization: user.token } }

      it 'returns 204 no content' do
        delete "/api/bookings/#{booking.id}", headers: auth

        expect(response).to have_http_status(:no_content)
      end

      it 'really deletes booking from DB' do
        booking

        expect do
          delete "/api/bookings/#{booking.id}", headers: auth
        end.to change(Booking, :count).by(-1)
      end
    end

    context 'when booking does not exist' do
      let(:user) { FactoryBot.create(:user) }
      let(:auth) { { Authorization: user.token } }

      it 'returns 404 not found' do
        delete '/api/bookings/1', headers: auth

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
