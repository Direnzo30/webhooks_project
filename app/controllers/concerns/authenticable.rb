# frozen_string_literal: true

# Module for validating
module Authenticable
  extend ActiveSupport::Concern

  included do
    attr_accessor :current_user

    def authenticate_user!
      authenticate_or_request_with_http_token do |token, _|
        @current_user = Authentication::AccessService.grant_access(token)
      end
    end
  end
end
