# frozen_string_literal: true

# Controller for handling the authentication endpoints
class AuthenticationController < ApplicationController
  def authenticate
    token = Authentication::AccessService.grant_jwt(access_params)
    render_raw_response({ token: token })
  end

  private

  def access_params
    params.require(:credentials).permit %i[email password]
  end
end
