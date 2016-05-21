require "assert_diff/version"
require "assert_diff/default_comparator"
require "assert_diff/differ"

module AssertDiff
  def assert_diff_equal(expected, actual)
    assert_equal(*Differ.new.diff(expected, actual))
  end

  def assert_diff_intersect(expected, actual)
    assert_equal(*Differ.new(intersect: false).diff(expected, actual))
  end
end
