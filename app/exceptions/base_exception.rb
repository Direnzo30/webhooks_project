# frozen_string_literal: true

# Manage the structure of the custom exceptions of the app
class BaseException < StandardError
  attr_reader :status_code

  def initialize(msg, status_code)
    @status_code = status_code
    super(msg)
  end
end
