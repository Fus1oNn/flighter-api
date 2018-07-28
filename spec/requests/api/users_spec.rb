RSpec.describe 'Users API', type: :request do
  include TestHelpers::JsonResponse

  describe 'GET /api/users' do
    let(:user) { FactoryBot.create(:user) }

    context 'when authenticated' do
      before { user }

      let(:auth) { { Authorization: user.token } }

      it 'returns a list of users' do
        get '/api/users', headers: auth

        expect(json_body['users'].length).to eq(1)
      end

      it 'returns 200 ok' do
        get '/api/users', headers: auth

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when not authenticated' do
      before { user }

      it 'returns an error response' do
        get '/api/users'

        expect(json_body['errors']).to include('token')
      end

      it 'returns status code 401 unauthorized' do
        get '/api/users'

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/users/:id' do
    let(:user) { FactoryBot.create(:user) }
    let(:auth) { { Authorization: user.token } }

    context 'when authenticated' do
      it 'returns the user in json' do
        get "/api/users/#{user.id}", headers: auth

        expect(json_body['user'])
          .to include('first_name' => user.first_name)
      end

      it 'returns 200 ok' do
        get "/api/users/#{user.id}", headers: auth

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when not authenticated' do
      it 'returns an error response' do
        get "/api/users/#{user.id}"

        expect(json_body['errors']).to include('token')
      end

      it 'returns status code 401 unauthorized' do
        get "/api/users/#{user.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when not authorized' do
      it 'returns 403 forbidden' do
        get '/api/users/1', headers: auth
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST /api/users' do
    let(:user) { FactoryBot.create(:user) }
    let(:auth) { { Authorization: user.token } }

    context 'when authenticated and params are valid' do
      let(:user_params) do
        { user: { email: 'nesto@gmail.com',
                  first_name: 'Mirko', password: 'password' } }
      end

      it 'creates a user' do
        post '/api/users', params: user_params, headers: auth

        expect(json_body['user']).to include('email' => 'nesto@gmail.com')
      end

      it 'returns 201 created' do
        post '/api/users', params: user_params, headers: auth

        expect(response).to have_http_status(:created)
      end

      it 'really creates user in DB' do
        user
        expect do
          post '/api/users', params: user_params, headers: auth
        end.to change(User, :count).by(1)
      end
    end

    context 'when authenticated and params are invalid' do
      it 'returns 400 bad request' do
        post '/api/users', params: { user: { first_name: '' } },
                           headers: auth

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns errors' do
        post '/api/users', params: { user: { first_name: '' } },
                           headers: auth

        expect(json_body['errors']).to include('first_name')
      end
    end

    context 'when not authenticated' do
      it 'returns an error response' do
        post '/api/users'

        expect(json_body['errors']).to include('token')
      end

      it 'returns status 401 unauthorized' do
        post '/api/users'

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /api/users/:id' do
    let(:user) { FactoryBot.create(:user) }
    let(:other) { FactoryBot.create(:user) }
    let(:auth) { { Authorization: user.token } }
    let(:user_params) { { user: { first_name: 'Empires' } } }

    context 'when authenticated and params are okay' do
      it 'updates user' do
        put "/api/users/#{user.id}", params: user_params, headers: auth

        expect(json_body['user']).to include('first_name' => 'Empires')
      end

      it 'returns 200 ok' do
        put "/api/users/#{user.id}", params: user_params, headers: auth

        expect(response).to have_http_status(:ok)
      end

      it 'really updated user in DB' do
        put "/api/users/#{user.id}", params: user_params, headers: auth

        user_after = User.find(user.id)

        expect(user_after.first_name).to eq('Empires')
      end
    end

    context 'when authenticated params not okay' do
      it 'returns 400 bad request' do
        put "/api/users/#{user.id}", params: { user: { first_name: '' } },
                                     headers: auth

        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when not authenticated' do
      it 'returns an error response' do
        put "/api/users/#{user.id}", params: user_params

        expect(json_body['errors']).to include('token')
      end

      it 'returns status 401 unauthorized' do
        put "/api/users/#{user.id}", params: user_params

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when not authorized' do
      it 'returns 401 forbidden' do
        put "/api/users/#{other.id}", params: user_params, headers: auth

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE /api/users/:id' do
    let(:user) { FactoryBot.create(:user) }
    let(:auth) { { Authorization: user.token } }

    context 'when authenticated and user exists' do
      it 'returns 204 no content' do
        delete "/api/users/#{user.id}", headers: auth

        expect(response).to have_http_status(:no_content)
      end

      it 'really deletes user from DB' do
        user

        expect do
          delete "/api/users/#{user.id}", headers: auth
        end.to change(User, :count).by(-1)
      end
    end

    context 'when not authenticated' do
      it 'returns an error response' do
        delete "/api/users/#{user.id}"

        expect(json_body['errors']).to include('token')
      end

      it 'returns status 401 unauthorized' do
        delete "/api/users/#{user.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when destroying some other user' do
      it 'returns 403 forbidden' do
        delete '/api/users/1', headers: auth

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
