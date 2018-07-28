RSpec.describe 'Bookings API', type: :request do
  include TestHelpers::JsonResponse

  describe 'GET /api/bookings' do
    let(:booking) { FactoryBot.create(:booking) }
    let(:user) { User.find(booking.user_id) }
    let(:auth) { { Authorization: user.token } }

    context 'when authenticated and a request is sent' do
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

    context 'when not authenticated' do
      it 'returns an error response' do
        get '/api/bookings'

        expect(json_body['errors']).to include('token')
      end

      it 'returns status 401 unauthorized' do
        get '/api/bookings'

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/bookings/:id' do
    let(:booking) { FactoryBot.create(:booking) }

    context 'when authenticated and booking exists' do
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

    context "when authenticated and booking doesn't exist" do
      let(:user) { FactoryBot.create(:user) }
      let(:auth) { { Authorization: user.token } }

      it 'returns 404 not found' do
        get '/api/bookings/1', headers: auth
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when not authenticated' do
      it 'returns an error response' do
        get "/api/bookings/#{booking.id}"

        expect(json_body['errors']).to include('token')
      end

      it 'returns status 401 unauthorized' do
        get "/api/bookings/#{booking.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when not authorized' do
      let(:other) { FactoryBot.create(:user) }

      it 'returns status 403 forbidden' do
        get "/api/bookings/#{booking.id}",
            headers: { Authorization: other.token }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST /api/bookings' do
    context 'when authenticated and params are valid' do
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

    context 'when authenticated and params are invalid' do
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

    context 'when not authenticated' do
      it 'returns an error response' do
        post '/api/bookings'

        expect(json_body['errors']).to include('token')
      end

      it 'returns status 401 unauthorized' do
        post '/api/bookings'

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /api/bookings/:id' do
    let(:booking) { FactoryBot.create(:booking) }
    let(:user) { User.find(booking.user_id) }
    let(:auth) { { Authorization: user.token } }

    context 'when authenticated and params are okay' do
      let(:booking_params) { { booking: { seat_price: 3 } } }

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

        expect(booking.reload.seat_price).to eq(3)
      end
    end

    context 'when authenticated and params not okay' do
      it 'returns 400 bad request' do
        put "/api/bookings/#{booking.id}", params: { booking:
                                                   { seat_price: 0 } },
                                           headers: auth

        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when not authenticated' do
      it 'returns an error response' do
        put "/api/bookings/#{booking.id}"

        expect(json_body['errors']).to include('token')
      end

      it 'returns status 401 unauthorized' do
        put "/api/bookings/#{booking.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when not authorized' do
      let(:other) { FactoryBot.create(:user) }

      it 'returns status 403 forbidden' do
        put "/api/bookings/#{booking.id}",
            headers: { Authorization: other.token }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE /api/bookings/:id' do
    let(:booking) { FactoryBot.create(:booking) }

    context 'when authenticated and booking exists' do
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

    context 'when authenticated and booking does not exist' do
      let(:user) { FactoryBot.create(:user) }
      let(:auth) { { Authorization: user.token } }

      it 'returns 404 not found' do
        delete '/api/bookings/1', headers: auth

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when not authenicated' do
      it 'returns an error response' do
        delete "/api/bookings/#{booking.id}"

        expect(json_body['errors']).to include('token')
      end

      it 'returns status 401 unauthorized' do
        delete "/api/bookings/#{booking.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when not authorized' do
      let(:other) { FactoryBot.create(:user) }

      it 'returns status 403 forbidden' do
        delete "/api/bookings/#{booking.id}",
               headers: { Authorization: other.token }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
