require "test_helper"

class AssertDiffTest < Minitest::Test
  include AssertDiff

  def test_that_it_has_a_version_number
    refute_nil ::AssertDiff::VERSION
  end

  def test_assert_hash_match
    assert_diff_equal(
      { "checkout" => { "token" => SecureRandom.hex, "billing_address" => { "zip" => "90210" } } },
      { "checkout" => { "token" => /\w+/, "billing_address" => { "zip" => "90210" } } },
    )
  end

  def test_assert_hash_intersect
    assert_diff_intersect(
      { "checkout" => { "token" => "123123", "billing_address" => { "zip" => "90210" } } },
      { "checkout" => { "token" => /\d+/ } },
    )
  end

  def test_assert_hash_intersect_with_class_match
    assert_diff_intersect(
      { "checkout" => { "token" => 123123, "billing_address" => { "zip" => "90210" } } },
      { "checkout" => { "token" => Integer } },
    )
  end
end
