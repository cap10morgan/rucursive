# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rucursive/version"

Gem::Specification.new do |s|
  s.name        = "rucursive"
  s.version     = Rucursive::VERSION
  s.authors     = ["Wes Morgan"]
  s.email       = ["cap10morgan@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Recursively traverses data structures}
  s.description = %q{Recursively traverses data structures (Hash & Array currently)}

  s.rubyforge_project = "rucursive"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "mocha"
  s.add_development_dependency "fuubar"
end
