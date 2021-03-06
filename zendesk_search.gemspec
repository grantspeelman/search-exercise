# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zendesk_search/version'

Gem::Specification.new do |spec|
  spec.name          = 'zendesk_search'
  spec.version       = ZendeskSearch::VERSION
  spec.authors       = ['Grant Petersen-Speelman']
  spec.email         = ['grantspeelman@gmail.com']

  spec.summary       = 'Zendesk Search'
  spec.description   = 'Zendesk Search'
  spec.homepage      = 'http://www.example.com'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_dependency 'highline', '~> 1.7', '>= 1.7.0'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
