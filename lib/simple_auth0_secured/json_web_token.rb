# frozen_string_literal: true

module SimpleAuth0Secured
  class JsonWebToken
    def self.verify(token)
      JWT.decode(
        token, nil,
        true, # Verify the signature of this token
        algorithm: 'RS256',
        iss: "#{auth0_url}/",
        verify_iss: true,
        aud: Simple::Auth0::Secured.configuration.auth0_api_audience,
        verify_aud: true
      ) { |header| jwks_hash[header['kid']] }
    end

    def self.jwks_hash
      jwks_raw  = Faraday.get "#{auth0_url}/.well-known/jwks.json"
      jwks_keys = Array(Oj.parse(jwks_raw)['keys'])
      Hash[jwks_keys.map { |k| [k['kid'], decoded(k)] }]
    end

    def self.decoded(key)
      OpenSSL::X509::Certificate.new(
        Base64.decode64(key['x5c'].first)
      ).public_key
    end

    def self.domain
      Simple::Auth0::Secured.configuration.auth0_tenant_domain
    end

    def self.auth0_url
      "https://#{domain}"
    end
  end
end
