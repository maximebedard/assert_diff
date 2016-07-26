require "test_helper"

class AssertDiffTest < Minitest::Test
  include AssertDiff

  def test_that_it_has_a_version_number
    refute_nil ::AssertDiff::VERSION
  end

  def test_assert_exact_diff
    assert_exact_diff(
      { "checkout" => { "token" => 123123, "billing_address" => { "zip" => "90210" } } },
      { "checkout" => { "token" => 123123, "billing_address" => { "zip" => "90210" } } },
    )
  end

  def test_assert_flexible_diff
    assert_flexible_diff(
      { "checkout" => { "token" => SecureRandom.hex, "billing_address" => { "zip" => "90210" } } },
      { "checkout" => { "token" => /\w+/, "billing_address" => { "zip" => "90210" } } },
    )
  end

  def test_assert_exact_diff_intersect
    assert_exact_diff_intersect(
      { "checkout" => { "token" => "123123", "billing_address" => { "zip" => "90210" } } },
      { "checkout" => { "billing_address" => { "zip" => "90210" } } },
    )
  end

  def test_assert_flexible_diff_intersect
    assert_flexible_diff_intersect(
      { "checkout" => { "token" => "123123", "billing_address" => { "zip" => "90210" } } },
      { "checkout" => { "token" => /\d+/ } },
    )
  end
end
