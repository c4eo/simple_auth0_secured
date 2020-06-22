require 'jwt'

module SimpleAuth0Secured
  class Client
    attr_accessor :token_verified

    def initialize(token)
      @token = token
      @token_verified = false
    end

    def verify!
      @auth0_user_id = token_decoded.first['sub']
      @token_verified = true
    end

    def user_info
      ckey = "SA0S_USER_INFO_#{auth0_user_id}"
      Rails.cache.fetch(ckey, expires_in: expiration_length) do
        Oj.load(Faraday.get(userinfo_url, {}, auth_header).body)
      end
    end

    def auth0_user_id
      return @auth0_user_id if @auth0_user_id

      raise StandardError,
            'No Auth0 user_id available. Maybe you need to call `verify!`'
    end

    private

    def auth_header
      { 'authorization' => "Bearer #{@token}" }
    end

    def expiration_length
      exp = Time.at(token_decoded.first['exp']) - 1.hour
      (exp - Time.zone.now).to_i
    end

    def token_decoded
      @token_decoded ||= JsonWebToken.verify(@token)
    end

    def userinfo_url
      domain = SimpleAuth0Secured.configuration.auth0_tenant_domain
      "https://#{domain}/userinfo"
    end
  end
end