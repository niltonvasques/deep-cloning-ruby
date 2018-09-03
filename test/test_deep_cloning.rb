require 'minitest/autorun'
require 'azure_ad'

# This class test all possible equations for this gem
class TestParsec < Minitest::Test
  def test_defined
    assert defined?(DeepCloning::DeepCloning)
    assert defined?(DeepCloning::DeepCloning::VERSION)
  end
end
