require 'test_helper'

class AssertDiffTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::AssertDiff::VERSION
  end

end
