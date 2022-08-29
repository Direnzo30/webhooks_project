# frozen_string_literal: true

# Module for rendering the api responses
module Renderable
  extend ActiveSupport::Concern

  included do
    rescue_from(StandardError) { |exception| manage_standand_error(exception) }
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from(BaseException) { |exception| manage_base_exception(exception) }

    private

    #
    # Renders a raw hash as response
    #
    # @param [Hash] data - The payload to be rendered
    # @param [Symbol] status - The HTTP status related to the response
    #
    # @return [Hash] The serialized response
    #
    def render_raw_response(data, status = :ok)
      render json: { data: data }, status: status
    end

    #
    # Renders a serialized model
    #
    # @param [Object] model - The model to be serialized
    # @param [JSONAPI::Serializer] serializer - The serializer for serializing the model
    # @param [Symbol] status - The HTTP status related to the response
    #
    # @return [Hash] The serialized model as response
    #
    def render_response(model, serializer, status = :ok)
      render json: serializer.new(model).serializable_hash, status: status
    end

    #
    # Renders a not found error in case the exception is raised
    #
    # @return [Hash] The response
    #
    def not_found
      render json: { error: 'Not Found' }, status: :not_found
    end

    #
    # Renders any exception raised that is not a BaseException
    #
    # @param [StandardError] exception - The raised exception
    #
    # @return [Hash] The response
    #
    def manage_standand_error(exception)
      render json: { errors: exception.message }, status: :internal_server_error
    end

    #
    # Renders the custom exceptions defined by the app
    #
    # @param [BaseException] base_exception - custom exception for handling different scenarios
    #
    # @return [Hash] The response
    #
    def manage_base_exception(base_exception)
      render json: { errors: base_exception.message }, status: base_exception.status_code
    end
  end
end
