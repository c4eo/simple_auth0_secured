# frozen_string_literal: true
require 'jwt'

module SimpleAuth0Secured
  # Verifies an Auth0-provided JWT using the Auth0 API
  class JsonWebToken
    def self.verify(token)
      JWT.decode(
        token, nil,
        true, # Verify the signature of this token
        algorithm: 'RS256',
        iss: "#{auth0_url}/",
        verify_iss: true,
        aud: SimpleAuth0Secured.configuration.auth0_api_audience,
        verify_aud: true
      ) { |header| jwks_hash[header['kid']] }
    end

    def self.jwks_hash
      jwks_keys = Array(Oj.load(cached_jwks_raw)['keys'])
      Hash[jwks_keys.map { |k| [k['kid'], decoded(k)] }]
    end

    def self.cached_jwks_raw
      Rails.cache.fetch('SA0S_JWKS_HASH', expires_in: 10.hours) do
        Faraday.get("#{auth0_url}/.well-known/jwks.json").body
      end
    end

    def self.decoded(key)
      OpenSSL::X509::Certificate.new(
        Base64.decode64(key['x5c'].first)
      ).public_key
    end

    def self.domain
      SimpleAuth0Secured.configuration.auth0_tenant_domain
    end

    def self.auth0_url
      "https://#{domain}"
    end
  end
end
