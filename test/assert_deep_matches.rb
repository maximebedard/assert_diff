require "test_helper"

class AssertDeepMatchesTest < Minitest::Test
  include AssertDeepMatches

  def test_that_it_has_a_version_number
    refute_nil ::AssertDeepMatches::VERSION
  end

  def test_assert_deep_matches_identical
    assert_deep_matches(
      { "checkout" => { "token" => 123123, "billing_address" => { "zip" => "90210" } } },
      { "checkout" => { "token" => 123123, "billing_address" => { "zip" => "90210" } } },
    )
  end

  def test_assert_deep_matches_array_identical
    assert_deep_matches(
      [{ "id" => "USPS-10.00", "price" => "10.00" }],
      [{ "id" => "USPS-10.00", "price" => "10.00" }],
    )
  end

  def test_assert_deep_matches
    assert_deep_matches(
      { "checkout" => { "token" => SecureRandom.hex, "billing_address" => { "zip" => "90210" } } },
      { "checkout" => { "token" => regexp_matches(/\w+/), "billing_address" => { "zip" => "90210" } } },
    )
  end

  def test_assert_deep_matches_union
    assert_deep_matches(
      { "checkout" => { "token" => "123123", "billing_address" => { "zip" => "90210" } } },
      { "checkout" => { "token" => regexp_matches(/\d+/) } },
      { relation: AssertDeepMatches::Relation::Union },
    )
  end

  def test_assert_deep_matches_array
    assert_deep_matches(
      [{ "id" => "USPS-10.00", "price" => "10.00" }],
      [{ "id" => regexp_matches(/\w+\-\d+\.\d+/), "price" => "10.00" }],
    )
  end

  def test_assert_deep_matches_union_array
    assert_deep_matches(
      [{ "id" => "USPS-10.00", "price" => "10.00" }],
      [{ "id" => regexp_matches(/\w+\-\d+\.\d+/) }],
      relation: AssertDeepMatches::Relation::Union,
    )
  end
end
