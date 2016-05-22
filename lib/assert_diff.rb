require "assert_diff/version"
require "assert_diff/comparators/exact"
require "assert_diff/comparators/flexible"
require "assert_diff/differ"

module AssertDiff
  def assert_diff_equal(expected, actual)
    a, b = Differ.new(comparator: Comparators::Flexible.new)
      .diff(expected, actual)

    assert_equal(a, b)
  end

  def assert_diff_intersect(expected, actual)
    a, b = Differ.new(comparator: Comparators::Flexible.new)
      .diff(expected, actual, intersection_only: true)

    assert_equal(a, b)
  end
end
