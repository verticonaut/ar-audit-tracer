# lorem.gemspec
# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'ar-audit-tracer/version'

Gem::Specification.new do |s|
  s.name        = %q{ar-audit-tracer}
  s.version     = ArAuditTracer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Martin Schweizer"]
  s.email       = %q{martin@verticonaut.me}
  s.homepage    = %q{http://github.com/verticonaut/ar-audit-tracer}
  s.summary     = %q{Track creator/modifiers of you AR Models similar to timestamps.}
  s.description = %q{Handles ActiveRecord authors in the same way as timstamps.}

  s.add_dependency              "activerecord", "~> 4.0"

  s.add_development_dependency  "sqlite3", "~> 0"

  s.rdoc_options  << '--charset' << 'UTF-8' << '--line-numbers'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

