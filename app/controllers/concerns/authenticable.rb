# frozen_string_literal: true

# Module for validating the requests Authorization header
module Authenticable
  extend ActiveSupport::Concern

  included do
    # @return [User] The authenticated user
    attr_accessor :current_user

    #
    # Validates the Authorization header for granting access
    #
    # @return [User] The user associated to the JWT
    #
    def authenticate_user!
      authenticate_or_request_with_http_token do |token, _|
        @current_user = Authentication::AccessService.grant_access(token)
      end
    end
  end
end
