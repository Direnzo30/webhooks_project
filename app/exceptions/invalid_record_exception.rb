# frozen_string_literal: true

# Class for handling invalid records exceptions raised by the app
class InvalidRecordException < BaseException
  def initialize(msg)
    super(msg, :unprocessable_entity)
  end
end
