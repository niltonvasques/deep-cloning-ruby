require 'rake/clean'
require 'rake/testtask'

task default: :spec

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/test_*.rb'
  test.verbose = true
end
