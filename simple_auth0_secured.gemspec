require_relative 'lib/simple_auth0_secured/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_auth0_secured"
  spec.version       = SimpleAuth0Secured::VERSION
  spec.authors       = ["Matt E. Patterson"]
  spec.email         = ["mpatterson@skillsengine.com"]

  spec.summary       = %q{Provides simple mechanisms for securing Rails APIs with Auth0}
  spec.description   = %q{Provides simple mechanisms for securing Rails APIs with Auth0}
  spec.homepage      = "https://github.com/c4eo/simple_auth0_secured"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.pkg.github.com/c4eo"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/c4eo/simple_auth0_secured"
  spec.metadata["changelog_uri"] = "https://github.com/c4eo/simple_auth0_secured/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'activesupport', '>= 5.2'
  spec.add_runtime_dependency 'configurations', '~> 2.2.0'
  spec.add_runtime_dependency 'faraday', '~> 1.3'
  spec.add_runtime_dependency 'jwt'
  spec.add_runtime_dependency 'oj', '>= 3.10'
  spec.add_runtime_dependency 'typhoeus'
end
