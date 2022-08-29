# frozen_string_literal: true

# Manage the invalid tokens exceptions raised in the app
class InvalidTokenException < BaseException
  def initialize
    msg = 'Invalid Token'
    super(msg, :unauthorized)
  end
end
