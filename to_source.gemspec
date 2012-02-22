# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "to_source/version"

Gem::Specification.new do |s|
  s.name        = "to_source"
  s.version     = ToSource::VERSION
  s.authors     = ["Josep M. Bach"]
  s.email       = ["josep.m.bach@gmail.com"]
  s.homepage    = "http://github.com/txus/to_source"
  s.summary     = %q{Transform your Rubinius AST nodes back to source code. Reverse parsing!}
  s.description = %q{Transform your Rubinius AST nodes back to source code. Reverse parsing!}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
