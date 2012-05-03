require 'rubypp'
require 'stringio'
require 'test/unit'

class RubyPPTest < Test::Unit::TestCase
  def test_preprocess
    input = File.open('test.cpp.rpp')
    output = StringIO.new()
    preprocessor = RubyPP.new(input, output, 'test.cpp.rpp')
    preprocessor.preprocess
    expected = File.read('test.cpp.expected')
    assert_equal expected, output.string
  end
end

