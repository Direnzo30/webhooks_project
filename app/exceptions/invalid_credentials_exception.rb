# frozen_string_literal: true

# Manage the invalid credentials exceptions raised in the app
class InvalidCredentialsException < BaseException
  def initialize
    msg = 'Invalid Credentials'
    super(msg, :unauthorized)
  end
end
