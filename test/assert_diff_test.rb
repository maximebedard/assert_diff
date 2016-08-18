require "test_helper"

class AssertDiffTest < Minitest::Test
  include AssertDiff

  def test_that_it_has_a_version_number
    refute_nil ::AssertDiff::VERSION
  end

  def test_assert_diff_same
    assert_diff_same(
      { "checkout" => { "token" => 123123, "billing_address" => { "zip" => "90210" } } },
      { "checkout" => { "token" => 123123, "billing_address" => { "zip" => "90210" } } },
    )
  end

  def test_assert_diff_same_union
    assert_diff_same_union(
      { "checkout" => { "token" => "123123", "billing_address" => { "zip" => "90210" } } },
      { "checkout" => { "billing_address" => { "zip" => "90210" } } },
    )
  end

  # def test_assert_diff_same_array
  #   assert_diff_same(
  #     [{ "id" => "USPS-10.00", "price" => "10.00" }, { "id" => "CP-8.00", "price" => "8.00" }],
  #     [{ "id" => "USPS-10.00", "price" => "10.00" }, { "id" => "CP-8.00", "price" => "8.00" }],
  #   )
  # end
  #
  # def test_assert_diff_same_union_array
  #   assert_diff_same(
  #     [{ "id" => "USPS-10.00", "price" => "10.00" }, { "id" => "CP-8.00", "price" => "10.00" }],
  #     [{ "id" => "USPS-10.00", "price" => "10.00" }, { "id" => "CP-8.00", "price" => "10.00" }],
  #   )
  # end

  def test_assert_diff_equal
    assert_diff_equal(
      { "checkout" => { "token" => SecureRandom.hex, "billing_address" => { "zip" => "90210" } } },
      { "checkout" => { "token" => /\w+/, "billing_address" => { "zip" => "90210" } } },
    )
  end

  def test_assert_diff_equal_union
    assert_diff_equal_union(
      { "checkout" => { "token" => "123123", "billing_address" => { "zip" => "90210" } } },
      { "checkout" => { "token" => /\d+/ } },
    )
  end

  # def test_assert_diff_equal_array
  # end
  #
  # def test_assert_diff_equal_union_array
  # end
end
