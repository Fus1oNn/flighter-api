RSpec.describe 'Sessions API', type: :request do
  include TestHelpers::JsonResponse

  describe 'POST /api/session' do
    context 'when successfuly authenticated' do
      let(:user) { FactoryBot.create(:user) }
      let(:session_params) do
        { session: { email: user.email, password: 'password' } }
      end

      it 'returns 201 created' do
        post '/api/session', params: session_params

        expect(response).to have_http_status(:created)
      end

      it 'returns token for user' do
        post '/api/session', params: session_params

        expect(json_body['session']).to include('token')
      end
    end

    context 'when unsuccessfuly authenicated' do
      let(:user) { FactoryBot.create(:user) }
      let(:session_params) do
        { session: { email: user.email, password: 'notpassword' } }
      end

      it 'returns 400 bad request' do
        post '/api/session', params: session_params

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message' do
        post '/api/session', params: session_params

        expect(json_body['errors']).to include('credentials')
      end
    end
  end

  describe 'DELETE /api/session' do
    context 'when authenticated' do
      let(:user) { FactoryBot.create(:user) }
      let(:auth) { { Authorization: user.token } }

      it 'returns status 204 no content' do
        delete '/api/session', headers: auth

        expect(response).to have_http_status(:no_content)
      end

      it 'regenerates new token for user' do
        user
        expect do
          delete '/api/session', headers: auth
        end.to(change { user.reload.token })
      end
    end

    context 'when not authenticated' do
      it 'returns status 401 unauthorized' do
        delete '/api/session'

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error response' do
        delete '/api/session'

        expect(json_body['errors']).to include('token')
      end
    end
  end
end
