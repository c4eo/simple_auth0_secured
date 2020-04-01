# frozen_string_literal: true

require 'jwt'
require 'pry'

module SimpleAuth0Secured
  # Provides a module that can be included in Rails controllers to provide
  # endpoint security based on the incoming JWT from Auth0
  module Secured
    extend ActiveSupport::Concern

    included do
      before_action :auth0_authenticate_request!
    end

    def auth0_client
      @auth0_client ||= SimpleAuth0Secured::Client.new(http_token)
    end

    private

    def auth0_authenticate_request!
      auth0_client.verify!
    rescue JWT::VerificationError, JWT::DecodeError => e
      Rails.logger.warn "Could not decode/verify Auth0 JWT: #{e.message}"
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
    end

    def http_token
      return if request.headers['Authorization'].blank?

      request.headers['Authorization'].split(' ').last
    end
  end
end
