require 'rubygems'
require 'rake'
require 'bundler'
Bundler::GemHelper.install_tasks


require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end


begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end


require 'rake/rdoctask'
require "ar-audit-tracer/version"
Rake::RDocTask.new do |rdoc|
  version = ArAuditTracer::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ar-audit-tracer #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => :test
