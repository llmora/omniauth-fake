# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-fake/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-fake"
  spec.version       = OmniAuth::Fake::VERSION
  spec.authors       = ["Manuel Hutter"]
  spec.email         = ["gem@mhutter.net"]
  spec.summary       = %q{A testing strategy for OmniAuth.}
  spec.description   = %q{A testing strategy for OmniAuth. Define your Identities in `~/.omniauth-fake`.}
  spec.homepage      = "https://github.com/mhutter/omniauth-fake"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'omniauth', '~> 1.0'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
