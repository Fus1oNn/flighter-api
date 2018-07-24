RSpec.describe 'Users API', type: :request do
  include TestHelpers::JsonResponse

  let(:user) { FactoryBot.create(:user) }

  describe 'GET /users' do
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
      before do
        post '/api/users',
             params: { user: { email: 'nesto@gmail.com', first_name: 'Mirko' } }
      end

      it 'creates a user' do
        expect(json_body['user'])
          .to include('email' => 'nesto@gmail.com')
      end

      it 'returns 201 created' do
        expect(response).to have_http_status(:created)
      end

      it 'really creates user in DB' do
        count_before = User.all.count

        post '/api/users',
             params: { user: { email: 'nikaj@gmail.com', first_name: 'Mirko' } }

        count_after = User.all.count

        expect(count_after).to eq(count_before + 1)
      end
    end

    context 'when params are invalid' do
      before { post '/api/users', params: { user: { first_name: '' } } }

      it 'returns 400 bad request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns errors' do
        expect(json_body['errors']).to include('first_name')
      end
    end
  end

  describe 'PUT /users/:id' do
    context 'when params are okay' do
      before do
        put "/api/users/#{user.id}", params: { user:
                                               { first_name: 'Empires' } }
      end

      it 'updates user' do
        expect(json_body['user']).to include('first_name' => 'Empires')
      end

      it 'returns 200 ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'really updated user in DB' do
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
      it 'returns 204 no content' do
        delete "/api/users/#{user.id}"

        expect(response).to have_http_status(:no_content)
      end

      it 'really deletes user from DB' do
        user

        count_before = User.all.count

        delete "/api/users/#{user.id}"

        count_after = User.all.count

        expect(count_after).to eq(count_before - 1)
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
