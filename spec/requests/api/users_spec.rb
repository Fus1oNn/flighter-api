RSpec.describe 'Users API', type: :request do
  let(:token) { User.find(booking.user_id).token }

  include TestHelpers::JsonResponse

  describe 'GET /users' do
    let(:user) { FactoryBot.create(:user) }

    context 'when a request is sent' do
      before { user }

      it 'returns a list of users' do
        get '/api/users'

        expect(json_body['users'].length).to eq(1)
      end

      it 'returns 200 ok' do
        get '/api/users'

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /users/:id' do
    context 'when users exists' do
      let(:user) { FactoryBot.create(:user) }

      it 'returns the user in json' do
        get "/api/users/#{user.id}"

        expect(json_body['user'])
          .to include('first_name' => user.first_name)
      end

      it 'returns 200 ok' do
        get "/api/users/#{user.id}"

        expect(response).to have_http_status(:ok)
      end
    end

    context "when user doesn't exist" do
      it 'returns 404 not found' do
        get '/api/users/1'
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /users' do
    context 'when params are valid' do
      let(:user_params) do
        { user: { email: 'nesto@gmail.com',
                  first_name: 'Mirko', password: 'password' } }
      end

      it 'creates a user' do
        post '/api/users', params: user_params

        expect(json_body['user']).to include('email' => 'nesto@gmail.com')
      end

      it 'returns 201 created' do
        post '/api/users', params: user_params

        expect(response).to have_http_status(:created)
      end

      it 'really creates user in DB' do
        expect do
          post '/api/users', params: user_params
        end.to change(User, :count).by(1)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 bad request' do
        post '/api/users', params: { user: { first_name: '' } }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns errors' do
        post '/api/users', params: { user: { first_name: '' } }

        expect(json_body['errors']).to include('first_name')
      end
    end
  end

  describe 'PUT /users/:id' do
    let(:user) { FactoryBot.create(:user) }

    context 'when params are okay' do
      let(:user_params) { { user: { first_name: 'Empires' } } }

      it 'updates user' do
        put "/api/users/#{user.id}", params: user_params

        expect(json_body['user']).to include('first_name' => 'Empires')
      end

      it 'returns 200 ok' do
        put "/api/users/#{user.id}", params: user_params

        expect(response).to have_http_status(:ok)
      end

      it 'really updated user in DB' do
        put "/api/users/#{user.id}", params: user_params

        user_after = User.find(user.id)

        expect(user_after.first_name).to eq('Empires')
      end
    end

    context 'when params not okay' do
      it 'returns 400 bad request' do
        put "/api/users/#{user.id}", params: { user: { first_name: '' } }

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'DELETE /users/:id' do
    context 'when user exists' do
      let(:user) { FactoryBot.create(:user) }

      it 'returns 204 no content' do
        delete "/api/users/#{user.id}"

        expect(response).to have_http_status(:no_content)
      end

      it 'really deletes user from DB' do
        user

        expect do
          delete "/api/users/#{user.id}"
        end.to change(User, :count).by(-1)
      end
    end

    context 'when user does not exist' do
      it 'returns 404 not found' do
        delete '/api/users/1'

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
