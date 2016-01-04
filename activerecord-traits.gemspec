# encoding: utf-8
require File.expand_path('../lib/traits/version', __FILE__)

Gem::Specification.new do |s|
  s.name            = 'activerecord-traits'
  s.version         = Traits::VERSION
  s.authors         = ['Yaroslav Konoplov']
  s.email           = ['yaroslav@inbox.com']
  s.summary         = 'Type information of ActiveRecord models, attributes and associations'
  s.description     = 'Type information of ActiveRecord models, attributes and associations'
  s.homepage        = 'http://github.com/yivo/activerecord-traits'
  s.license         = 'MIT'

  s.executables     = `git ls-files -z -- bin/*`.split("\x0").map{ |f| File.basename(f) }
  s.files           = `git ls-files -z`.split("\x0")
  s.test_files      = `git ls-files -z -- {test,spec,features}/*`.split("\x0")
  s.require_paths   = ['lib']

  s.add_dependency 'activesupport', '>= 3.2.0'
  s.add_dependency 'activerecord', '>= 3.2.0'
  s.add_dependency 'essay', '~> 1.0.0'
  s.add_dependency 'essay-globalize', '~> 1.0.0'
  s.add_dependency 'essay-carrierwave', '~> 1.0.0'
end