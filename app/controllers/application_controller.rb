# frozen_string_literal: true

# Base class for all controllers
class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include Authenticable
  include Renderable
end
