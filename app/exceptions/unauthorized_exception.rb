# frozen_string_literal: true

# Manage the unauthorized exceptions raised in the app
class UnauthorizedException < BaseException
  def initialize
    msg = 'User unauthorized for action'
    super(msg, :unauthorized)
  end
end
