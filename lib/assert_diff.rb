require "assert_diff/version"
require "assert_diff/differ"

module AssertDiff
  def assert_strict_diff(expected, actual)
    assert_equal(*Differ.diff(expected, actual))
  end

  def assert_loose_diff(expected, actual)
    assert_equal(*Differ.diff(expected, actual, strict: false))
  end
end
