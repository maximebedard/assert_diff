require "assert_diff/version"
require "assert_diff/comparators/same"
require "assert_diff/comparators/flexible"
require "assert_diff/differ"

module AssertDiff
  module Relation
    Union = -> (a, b) { a & b }
    Intersection = -> (a, b) { a | b }
    Difference = -> (a, b) { a - b }
    SymmetricDifference = -> (a, b) { a & b | b & a }
  end

  def assert_diff_same(expected, actual, **options)
    assert_diff(
      expected,
      actual,
      comparator: Comparators::Same.new,
      relation: Relation::Intersection,
      **options,
    )
  end

  def assert_diff_same_union(expected, actual, **options)
    assert_diff(
      expected,
      actual,
      comparator: Comparators::Same.new,
      relation: Relation::Union,
      **options,
    )
  end

  def assert_diff_equal(expected, actual, **options)
    assert_diff(
      expected,
      actual,
      comparator: Comparators::Flexible.new,
      relation: Relation::Intersection,
      **options,
    )
  end

  def assert_diff_equal_union(expected, actual, **options)
    assert_diff(
      expected,
      actual,
      comparator: Comparators::Flexible.new,
      relation: Relation::Union,
      **options,
    )
  end

  private

  def assert_diff(expected, actual, comparator:, relation:, **options)
    a, b = Differ.new(
      comparator: comparator,
      relation: relation,
    ).diff(expected, actual)

    assert_equal(a, b, **options)
  end
end
