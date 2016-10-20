# frozen_string_literal: true
require File.expand_path('../lib/traits/version', __FILE__)

Gem::Specification.new do |s|
  s.name            = 'activerecord-traits'
  s.version         = Traits::VERSION
  s.authors         = ['Yaroslav Konoplov']
  s.email           = ['eahome00@gmail.com']
  s.summary         = 'Type information of activerecord models'
  s.description     = 'Type information of activerecord models, attributes and associations in good and clear manner'
  s.homepage        = 'http://github.com/yivo/activerecord-traits'
  s.license         = 'MIT'

  s.executables     = `git ls-files -z -- bin/*`.split("\x0").map{ |f| File.basename(f) }
  s.files           = `git ls-files -z`.split("\x0")
  s.test_files      = `git ls-files -z -- {test,spec,features}/*`.split("\x0")
  s.require_paths   = ['lib']

  s.add_dependency 'activesupport', '>= 3.0', '< 6.0'
  s.add_dependency 'activerecord',  '>= 3.0', '< 6.0'
  s.add_dependency 'essay',         '~> 1.0'
end
