require "mocha/parameter_matchers"

require "assert_deep_matches/version"
require "assert_deep_matches/deep_matcher"

module AssertDeepMatches
  include Mocha::ParameterMatchers

  module Relation
    Union = -> (a, b) { a & b }
    Intersection = -> (a, b) { a | b }
    Difference = -> (a, b) { a - b }
    SymmetricDifference = -> (a, b) { a & b | b & a }
  end

  def assert_deep_matches(expected, actual, relation: Relation::Intersection, **options)
    a, b = DeepMatcher.new(relation: relation)
      .diff(expected, actual)

    assert_equal(a, b, **options)
  end
end
