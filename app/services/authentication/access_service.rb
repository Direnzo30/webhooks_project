# frozen_string_literal: true

module Authentication
  # Service for validating the received JWT and grant access
  class AccessService
    #
    # Validates the credentials (email, password) for granting a JWT
    #
    # @param [Hash] params - payload with the email and password
    #
    # @return [String] The jwt
    #
    def self.grant_jwt(params)
      user = User.find_by(email: params[:email])
      raise InvalidCredentialsException unless user && user.authenticate(params[:password]).present?

      Authentication::JwtService.encode(user.id)
    end

    #
    # Validates the JWT for allowing the access
    #
    # @param [String] token - The JWT
    #
    # @return [User] The user associated to the JTW
    #
    def self.grant_access(token)
      payload = Authentication::JwtService.decode(token)
      validate_payload! payload
      user = User.find_by(id: payload['user_id'])
      raise UnauthorizedException if user.blank?

      user
    end

    #
    # Validates the structure of the JWT payload
    #
    # @param [Hash] payload - The JWT payload
    #
    # @return [nil]
    #
    def self.validate_payload!(payload)
      raise UnauthorizedException if payload['exp'].blank? || payload['user_id'].blank?
      raise UnauthorizedException if Time.now.to_i > payload['exp'].to_i
    end
  end
end
