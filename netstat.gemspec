# -*- encoding: utf-8 -*-
require File.expand_path('../lib/netstat/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Donald Plummer"]
  gem.email         = ["donald@cideasphere.com"]
  gem.description   = %q{A Ruby interface for /proc/net/tcp}
  gem.summary       = gem.description
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "netstat"
  gem.require_paths = ["lib"]
  gem.version       = Netstat::VERSION
end
