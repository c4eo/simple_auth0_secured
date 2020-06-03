# frozen_string_literal: true

require 'configurations'
require 'simple_auth0_secured/version'
require 'simple_auth0_secured/json_web_token'
require 'simple_auth0_secured/client'
require 'simple_auth0_secured/secured'

module SimpleAuth0Secured
  include Configurations

  not_configured { |c| raise(NoMethodError, "#{c} must be configured") }

  configurable :auth0_tenant_domain,
               :auth0_api_audience,
               :auth0_issuer

  class Error < StandardError; end
end
