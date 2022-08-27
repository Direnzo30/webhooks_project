# frozen_string_literal: true

module Authentication
  # Service for validating the received JWT and grant access
  class AccessService
    def self.grant_jwt(params)
      user = User.find_by(email: params[:email])
      raise InvalidCredentialsException unless user && user.authenticate(params[:password]).present?

      Authentication::JwtService.encode(user.id)
    end

    def self.grant_access(token)
      payload = Authentication::JwtService.decode(token)
      validate_payload! payload
      user = User.find_by(id: payload['user_id'])
      raise UnauthorizedException if user.blank?

      user
    end

    def self.validate_payload!(payload)
      raise UnauthorizedException if payload['exp'].blank? || payload['user_id'].blank?
      raise UnauthorizedException if Time.now.to_i > payload['exp'].to_i
    end
  end
end
