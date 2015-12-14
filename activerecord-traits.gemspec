# encoding: utf-8
require File.expand_path('../lib/activerecord-traits/version', __FILE__)

Gem::Specification.new do |s|
  s.name            = 'activerecord-traits'
  s.version         = Traits::VERSION
  s.authors         = ['Yaroslav Konoplov']
  s.email           = ['yaroslav@inbox.com']
  s.summary         = 'Wrapper around ActiveRecord::Reflection'
  s.description     = 'Wrapper around ActiveRecord::Reflection'
  s.homepage        = 'http://github.com/yivo/activerecord-traits'
  s.license         = 'MIT'

  s.executables     = `git ls-files -z -- bin/*`.split("\x0").map{ |f| File.basename(f) }
  s.files           = `git ls-files -z`.split("\x0")
  s.test_files      = `git ls-files -z -- {test,spec,features}/*`.split("\x0")
  s.require_paths   = ['lib']

  s.add_dependency 'activesupport', '>= 3.2.0'
  s.add_dependency 'activerecord', '>= 3.2.0'
end