require "assert_diff/version"
require "assert_diff/comparators/exact"
require "assert_diff/comparators/flexible"
require "assert_diff/subsetters/intersection"
require "assert_diff/subsetters/union"
require "assert_diff/differ"

module AssertDiff
  def assert_exact_diff(expected, actual, **options)
    assert_diff(
      expected,
      actual,
      comparator: Comparators::Exact.new,
      subsetter: Subsetters::Union.new,
      **options,
    )
  end

  def assert_exact_diff_intersect(expected, actual, **options)
    assert_diff(
      expected,
      actual,
      comparator: Comparators::Exact.new,
      subsetter: Subsetters::Intersection.new,
      **options,
    )
  end

  def assert_flexible_diff(expected, actual, **options)
    assert_diff(
      expected,
      actual,
      comparator: Comparators::Flexible.new,
      subsetter: Subsetters::Union.new,
      **options,
    )
  end

  def assert_flexible_diff_intersect(expected, actual, **options)
    assert_diff(
      expected,
      actual,
      comparator: Comparators::Flexible.new,
      subsetter: Subsetters::Intersection.new,
      **options,
    )
  end

  def assert_diff(expected, actual, comparator:, subsetter:, **options)
    a, b = Differ.new(
      comparator: comparator,
      subsetter: subsetter,
    ).diff(expected, actual)

    assert_equal(a, b, **options)
  end
end
