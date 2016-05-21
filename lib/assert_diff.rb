require "assert_diff/version"
require "assert_diff/differ"

module AssertDiff
  def assert_diff_equal(expected, actual)
    assert_equal(*Differ.diff(expected, actual))
  end

  def assert_diff_intersect(expected, actual)
    assert_equal(*Differ.diff(expected, actual, strict: false))
  end
end
