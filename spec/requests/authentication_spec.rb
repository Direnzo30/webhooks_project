# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe '#authentication_path' do
    let(:user) { create(:user) }

    context 'when credentials are valid' do
      let(:params) do
        {
          credentials: {
            email: user.email,
            password: user.password
          }
        }
      end

      it 'responds with ok status and the token' do
        post authentication_path, params: params
        expect(response).to have_http_status(:ok)
        expect(json_response.dig(:data, :token)).not_to be_nil
      end
    end

    context 'when credentials are invalid' do
      let(:params) do
        {
          credentials: {
            email: user.email,
            password: 'not the one'
          }
        }
      end

      it 'responds with a unauthorized status' do
        post authentication_path, params: params
        expect(response).to have_http_status(:unauthorized)
        expect(json_response[:errors]).to eq('Invalid Credentials')
      end
    end
  end
end
