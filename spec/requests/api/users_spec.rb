RSpec.describe 'Users API', type: :request do
  # let(:user) { FactoryBot.create(:user) }
  # let(:auth) { { Authorization: user.token } }

  include TestHelpers::JsonResponse

  describe 'GET /users' do
    let(:user) { FactoryBot.create(:user) }

    context 'when a request is sent' do
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
  end

  describe 'GET /users/:id' do
    let(:user) { FactoryBot.create(:user) }
    let(:auth) { { Authorization: user.token } }

    context 'when users exists' do
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

    context "when it's some other user" do
      it 'returns 403 forbidden' do
        get '/api/users/1', headers: auth
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST /users' do
    let(:user) { FactoryBot.create(:user) }
    let(:auth) { { Authorization: user.token } }

    context 'when params are valid' do
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

    context 'when params are invalid' do
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
  end

  describe 'PUT /users/:id' do
    let(:user) { FactoryBot.create(:user) }
    let(:auth) { { Authorization: user.token } }

    context 'when params are okay' do
      let(:user_params) { { user: { first_name: 'Empires' } } }

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

    context 'when params not okay' do
      it 'returns 400 bad request' do
        put "/api/users/#{user.id}", params: { user: { first_name: '' } },
                                     headers: auth

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'DELETE /users/:id' do
    let(:user) { FactoryBot.create(:user) }
    let(:auth) { { Authorization: user.token } }

    context 'when user exists' do
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

    context 'when destroying some other user' do
      it 'returns 403 forbidden' do
        delete '/api/users/1', headers: auth

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
