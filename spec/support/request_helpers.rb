# frozen_string_literal: true

module RequestTestHelpers
  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end
end

RSpec.configure do |config|
  config.include RequestTestHelpers, type: :request
  config.include ActiveSupport::Testing::TimeHelpers, type: :request
end
