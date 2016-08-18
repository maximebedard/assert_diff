# assert_diff

# Why

When building an api, it's important that that the exposed attributes are never removed. To avoid
regression, an easy solution is to check the keys exposed, then actually compare the values when required. However, this has many problems:
- [Multiple assertions per test](http://programmers.stackexchange.com/questions/7823/is-it-ok-to-have-multiple-asserts-in-a-single-unit-test)
- Hard to maintain
- Shitty error message

## Example

```rb
def assert_keys(keys)
  assert_equal(
    [:title, :price, :id].sort,
    keys,
  )
end

test "retreive shipping rates" do
  get(
    "api/shipping_rates.json",
    params: { checkout_token: "d5c872c5924e9beb7f582103219e4586" },
    format: :json,
  )

  json = JSON.parse(response.body)
  json.each do |shipping_rate|
    assert_keys(shipping_rate)
  end

  assert_equal 2, json.size

  assert_equal "UPS Ground", json[0]["title"]
  assert_equal "10.00", json[0]["price"]
  assert_equal "UPS-10.00", json[0]["id"]
  assert_not_nil json[0]["rand_token"]

  assert_equal "Canada Post", json[1]["title"]
  assert_equal "8.00", json[1]["price"]
  assert_equal "CP-10.00", json[1]["id"]
  assert_not_nil json[1]["rand_token"]
end
```

## Improved example

```rb
test "retreive shipping rates" do
  get(
    "api/shipping_rates.json",
    params: { checkout_token: "d5c872c5924e9beb7f582103219e4586" },
    format: :json,
  )

  assert_diff_equal(
    [
      { "title" => "UPS Ground", "price" => "10.00", "id" => "UPS-10.00", "rand_token" => /\w+/ },
      { "title" => "UPS Ground", "price" => "8.00", "id" => "CP-8.00", "rand_token" => /\w+/ },
    ],
    JSON.parse(response.body),
  )
end
```

# Other features

Compare all the keys

```rb
assert_diff_equal(
  { "checkout" => { "token" => SecureRandom.hex, "billing_address" => { "zip" => "90210" } } },
  { "checkout" => { "token" => /\w+/, "billing_address" => { "zip" => "90210" } } },
)
```

Compare only a subset of the keys

```rb
assert_diff_equal_union(
  { "checkout" => { "token" => "123123", "billing_address" => { "zip" => "90210" } } },
  { "checkout" => { "token" => /\d+/ } },
)
```

# FAQ

> Why this over ActiveSupport/CoreExtensions/Hash/Diff/diff

Because it didn't support deep comparaison, nor arrays

> Why not override MiniTest::Assertions::diff

Nothing prevents doing something similar to the following:

```rb
def with_custom_differ(expected, actual)
  @original_differ = self.class.diff
  self.class.diff = AssertDiff::Differ.new(expected, actual)

  yield
ensure
  self.class.diff = @original_differ
end

def assert_diff_equal(expected, actual, *args)
  with_custom_differ(expected, actual) do
    assert_equal(expected, actual, *args)
  end
end

# dunnolol, haven't tried it.
```

But essentially minitest pipes the string representation on the object into the
system's differ. This implementations actually compares the value using a comparator,
which allows type coercion or pattern matching. It also allows specifying the relation between
the keys being observed (Union, Intersection, Difference, SymmetricDifference, etc.).

> Production ready?

Of course™.

# What's missing

Prettier formatting. Make sure assert*.same works correctly, pretty sure the tests are bad.

# References

[HashDiff](https://github.com/liufengyun/hashdiff)
[Deep diff](https://gist.github.com/henrik/146844)
[Rails/Hash/Diff](http://apidock.com/rails/Hash/diff)
[rspec diff](https://relishapp.com/rspec/rspec-expectations/docs/diffing)
[minitest assertions](http://ruby-doc.org/stdlib-2.0.0/libdoc/minitest/rdoc/MiniTest/Assertions.html#method-i-diff)
