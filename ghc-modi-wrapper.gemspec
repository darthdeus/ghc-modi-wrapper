# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ghc-modi-wrapper'
require 'ghc-modi-wrapper/version'

Gem::Specification.new do |spec|
  spec.name          = "ghc-modi-wrapper"
  spec.version       = GhcModiWrapper::VERSION
  spec.authors       = ["Jakub Arnold"]
  spec.email         = ["darthdeus@gmail.com"]
  spec.summary       = %q{ghc-mod wrapper for VIM ... because syntastic can't do async}
  spec.description   = %q{ghc-mod wrapper for VIM ... because syntastic can't do async}
  spec.homepage      = "http://github.com/darthdeus/ghc-modi-wrapper"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
