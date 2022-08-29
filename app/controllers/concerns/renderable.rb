# frozen_string_literal: true

# Module for rendering the api responses
module Renderable
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from(StandardError) { |exception| manage_standand_error(exception) }
    rescue_from(BaseException) { |exception| manage_base_exception(exception) }

    private

    def render_raw_response(data, status = :ok)
      render json: { data: data }, status: status
    end

    def render_response(object, serializer, status = :ok)
      render json: serializer.new(object).serializable_hash, status: status
    end

    def not_found
      render json: { error: 'Not Found' }, status: :not_found
    end

    def manage_standand_error(exception)
      render json: { errors: exception.message }, status: :internal_server_error
    end

    def manage_base_exception(base_exception)
      render json: { errors: base_exception.message }, status: base_exception.status_code
    end
  end
end
