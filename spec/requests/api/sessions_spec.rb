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
end
