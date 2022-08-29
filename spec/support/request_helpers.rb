# frozen_string_literal: true

module RequestTestHelpers
  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end

  def authenticated_get(route:, user: nil, params: {}, headers: {})
    user ||= create(:user)
    token = Authentication::JwtService.encode(user.id)
    get route, params: params, headers: headers.merge({ 'Authorization' => "Bearer #{token}" })
  end

  def authenticated_post(route:, user: nil, params: {}, headers: {})
    user ||= create(:user)
    token = Authentication::JwtService.encode(user.id)
    post route, params: params, headers: headers.merge({ 'Authorization' => "Bearer #{token}" })
  end

  def authenticated_patch(route:, user: nil, params: {}, headers: {})
    user ||= create(:user)
    token = Authentication::JwtService.encode(user.id)
    patch route, params: params, headers: headers.merge({ 'Authorization' => "Bearer #{token}" })
  end

  def authenticated_delete(route:, user: nil, params: {}, headers: {})
    user ||= create(:user)
    token = Authentication::JwtService.encode(user.id)
    delete route, params: params, headers: headers.merge({ 'Authorization' => "Bearer #{token}" })
  end
end

RSpec.configure do |config|
  config.include RequestTestHelpers, type: :request
  config.include ActiveSupport::Testing::TimeHelpers, type: :request
end
