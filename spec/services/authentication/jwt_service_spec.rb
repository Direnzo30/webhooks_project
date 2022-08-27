# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authentication::JwtService do
  subject(:jwt_service) { described_class }

  describe '#encode' do
    context 'when there is an error during the encoding' do
      it 'raises an invalid token exception' do
        allow(JWT).to receive(:encode).and_raise(StandardError)
        expect { jwt_service.encode(1) }.to raise_error(InvalidTokenException)
      end
    end

    context 'when there is no error during the encoding' do
      let(:jwt) { 'xxx.xxx.xxx' }

      it 'returns the jwt' do
        allow(JWT).to receive(:encode).and_return(jwt)
        expect(jwt_service.encode(1)).to eq(jwt)
      end
    end
  end

  describe '#decode' do
    context 'when the token is invalid' do
      it 'raises an invalid token exception' do
        expect { jwt_service.decode('') }.to raise_error(InvalidTokenException)
      end
    end

    context 'when the token is valid' do
      let(:jwt_response) do
        [{ 'user_id' => 1 }, { 'alg' => 'HS256' }]
      end

      it 'returns the token payload' do
        allow(JWT).to receive(:decode).and_return(jwt_response)
        expect(jwt_service.decode('')).to eq(jwt_response.first)
      end
    end
  end
end
