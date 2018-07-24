RSpec.describe 'Users API', type: :request do
  include TestHelpers::JsonResponse

  let(:user) { FactoryBot.create(:user) }

  describe 'GET /users' do
    context 'when a request is sent' do
      it 'returns a list of users' do
        user

        get '/api/users'

        expect(json_body['users'].length).to eq(1)
      end
    end
  end

  describe 'GET /users/:id' do
    context 'when users exists' do
      it 'returns the user in json' do
        get "/api/users/#{user.id}"

        expect(json_body['user'])
          .to include('first_name' => user.first_name)
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
      it 'creates a user' do
        post '/api/users',
             params: { user: { email: 'nesto@gmail.com', first_name: 'Mirko' } }
        expect(json_body['user'])
          .to include('email' => 'nesto@gmail.com')
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
    context 'when params are okay' do
      it 'updates user' do
        put "/api/users/#{user.id}", params: { user:
                                               { first_name: 'Empires' } }

        expect(json_body['user']).to include('first_name' => 'Empires')
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
      it 'returns 204 no content' do
        delete "/api/users/#{user.id}"

        expect(response).to have_http_status(:no_content)
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
