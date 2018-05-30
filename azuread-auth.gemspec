Gem::Specification.new do |s|
  s.name               = 'azuread-auth'
  s.version            = '0.1.0'
  s.platform           = Gem::Platform::RUBY
  s.authors            = ['Nilton Vasques']
  s.email              = ['nilton.vasques@gmail.com']
  s.description        = 'AzureAD Authentication'
  s.homepage           = 'https://github.com/niltonvasques/azuread-auth'
  s.summary            = 'A gem to authenticate against AzureAD'
  s.files              = ['lib/azure_ad.rb']
  s.test_files         = ['test/test_azure_ad.rb']
  s.require_paths      = ['lib']
  s.license            = 'mit'

  s.add_development_dependency 'minitest', '~> 5.10'
  s.add_development_dependency 'rake', '~> 12.1'
end
