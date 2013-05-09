# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'family/version'

Gem::Specification.new do |gem|
  gem.name          = "family"
  gem.version       = Family::VERSION
  gem.authors       = ["Yonah Forst"]
  gem.email         = ["joshblour@hotmail.com"]
  gem.description   = %q{builds happy families}
  gem.summary       = %q{creates relationships between objects}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
