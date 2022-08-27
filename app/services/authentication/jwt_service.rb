# frozen_string_literal: true

module Authentication
  # Service to encode and decode the JWT
  class JwtService
    JWT_KEY = Rails.application.secrets.secret_key_base.to_s
    EXPIRATION_TIME = 24.hours
    ENCODE_ALG = 'HS256'

    def self.encode(user_id)
      iat = Time.now.to_i
      payload = {
        'iat' => iat,
        'exp' => iat + EXPIRATION_TIME.to_i,
        'user_id' => user_id
      }
      JWT.encode payload, JWT_KEY, ENCODE_ALG
    rescue StandardError
      raise InvalidTokenException
    end

    def self.decode(token)
      JWT.decode(token, JWT_KEY, true, { algorithm: ENCODE_ALG }).first
    rescue StandardError
      raise InvalidTokenException
    end
  end
end
