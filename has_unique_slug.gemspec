# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "has_unique_slug/version"

Gem::Specification.new do |s|
  s.name        = "has_unique_slug"
  s.version     = HasUniqueSlug::VERSION
  s.authors     = ["Brendan Stennett"]
  s.email       = ["brendan@unknowncollective.com"]
  s.homepage    = "https://github.com/HuffMoody/has_unique_slug"
  s.summary     = "Generates a unique slug for use as a drop-in replacement for ids."
  s.description = "Generates a unique slug for use as a drop-in replacement for ids."

  s.rubyforge_project = "has_unique_slug"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "activerecord"
  s.add_development_dependency "sqlite3"
  # s.add_runtime_dependency "rest-client"
end
