require "simple_auth0_secured/version"

module SimpleAuth0Secured
  include Configurations

  not_configured { |c| raise(NoMethodError, "#{c} must be configured") }

  configurable :auth0_tenant_domain,
               :auth0_api_audience

  class Error < StandardError; end
  # Your code goes here...
end
