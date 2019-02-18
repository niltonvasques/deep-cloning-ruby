Gem::Specification.new do |s|
  s.name               = 'deep-cloning'
  s.version            = '0.1.4'
  s.platform           = Gem::Platform::RUBY
  s.authors            = ['Nilton Vasques']
  s.email              = ['nilton.vasques@gmail.com']
  s.description        = 'DeepCloning is a gem that is able to replicate a set of records in depth'
  s.homepage           = 'https://github.com/niltonvasques/deep-cloning'
  s.summary            = 'DeepCloning is a gem that is able to replicate a set of records in depth'
  s.files              = ['lib/deep_cloning.rb']
  s.test_files         = ['test/test_deep_cloning.rb']
  s.require_paths      = ['lib']
  s.license            = 'MIT'

  s.add_development_dependency 'minitest', '~> 5.10'
  s.add_development_dependency 'rake', '~> 12.1'
  s.add_dependency 'activerecord', '~> 4.2'
end
