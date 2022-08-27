# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authentication::AccessService do
  subject(:access_service) { described_class }

  let!(:user) { create(:user) }

  describe '#grant_jwt' do
    context 'when the email does not exist' do
      let!(:params) do
        {
          email: 'noexist@no.com'
        }
      end

      it 'raises and invalid credentials execption' do
        expect { access_service.grant_jwt(params) }.to raise_error(InvalidCredentialsException)
      end
    end

    context 'when the password is invalid' do
      let!(:params) do
        {
          email: user.email,
          password: 'invalid'
        }
      end

      it 'raises and invalid credentials execption' do
        expect { access_service.grant_jwt(params) }.to raise_error(InvalidCredentialsException)
      end
    end

    context 'when the credentials are valid' do
      let!(:params) do
        {
          email: user.email,
          password: user.password
        }
      end

      it 'generates the jwt' do
        expect { access_service.grant_jwt(params) }.not_to raise_error
      end
    end
  end

  describe '#grant_access' do
    context 'when the token is not valid' do
      it 'raises an invalid token exception' do
        expect { access_service.grant_access('') }.to raise_error(InvalidTokenException)
      end
    end

    context 'when the token payload is invalid' do
      it 'raises an unauthorized exception' do
        allow(Authentication::JwtService).to receive(:decode).and_return({})
        expect { access_service.grant_access('') }.to raise_error(UnauthorizedException)
      end
    end

    context 'when the token is expired' do
      it 'raises an unauthorized exception' do
        allow(Authentication::JwtService).to receive(:decode).and_return({ 'exp' => 1.day.ago })
        expect { access_service.grant_access('') }.to raise_error(UnauthorizedException)
      end
    end

    context 'when the user does not exist' do
      it 'raises an unauthorized exception' do
        allow(Authentication::JwtService).to receive(:decode).and_return({ 'user_id' => 0 })
        expect { access_service.grant_access('') }.to raise_error(UnauthorizedException)
      end
    end

    context 'when the token is valid' do
      it 'returns the associated user and grants access' do
        allow(Authentication::JwtService).to receive(:decode).and_return({ 'exp' => 1.day.from_now,
                                                                           'user_id' => user.id })
        expect(access_service.grant_access('')).to eq(user)
      end
    end
  end
end
