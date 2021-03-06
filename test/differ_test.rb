require "test_helper"

module AssertDiff
  class DifferTest < Minitest::Test
    def setup
      @differ = Differ.new
    end

    def test_same_value
      a, b = @differ.diff({ a: "bonjour" }, { a: "bonjour" })
      assert_nil a
      assert_nil b
    end

    def test_different_value
      a, b = @differ.diff({ a: "bonjour" }, { a: "allo" })
      assert_equal({ a: "bonjour" }, a)
      assert_equal({ a: "allo" }, b)
    end

    def test_with_same_and_different_value
      a, b = @differ.diff({ a: "bonjour", b: "yolo" }, { a: "allo", b: "yolo" })
      assert_equal({ a: "bonjour" }, a)
      assert_equal({ a: "allo" }, b)
    end

    def test_same_values
      a, b = @differ.diff({ a: %w(bonjour allo) }, { a: %w(bonjour allo) })
      assert_nil a
      assert_nil b
    end

    def test_different_values
      a, b = @differ.diff({ a: %w(bonjour allo) }, { a: %w(yellow molo) })
      assert_equal({ a: %w(bonjour allo) }, a)
      assert_equal({ a: %w(yellow molo) }, b)
    end

    def test_with_same_and_different_values
      a, b = @differ.diff({ a: %w(bonjour allo) }, { a: %w(bonjour yolo) })
      assert_equal({ a: [nil, "allo"] }, a)
      assert_equal({ a: [nil, "yolo"] }, b)
    end

    def test_same_hash_values
      a, b = @differ.diff(
        { a: [{ a: "bonjour" }, { b: "allo" }] },
        { a: [{ a: "bonjour" }, { b: "allo" }] },
      )
      assert_nil a
      assert_nil b
    end

    def test_different_hash_values
      a, b = @differ.diff(
        { a: [{ a: "bonjour" }, { b: "allo" }] },
        { a: [{ a: "yellow" }, { b: "molo" }] },
      )
      assert_equal({ a: [{ a: "bonjour" }, { b: "allo" }] }, a)
      assert_equal({ a: [{ a: "yellow" }, { b: "molo" }] }, b)
    end

    def test_with_same_and_different_hash_values
      a, b = @differ.diff(
        { a: [{ a: "bonjour" }, { b: "allo" }] },
        { a: [{ a: "bonjour" }, { b: "molo" }] },
      )
      assert_equal({ a: [nil, { b: "allo" }] }, a)
      assert_equal({ a: [nil, { b: "molo" }] }, b)
    end

    def test_same_array_values
      a, b = @differ.diff({ a: %w(bonjour allo) }, { a: %w(bonjour allo) })
      assert_nil a
      assert_nil b
    end

    def test_different_array_values
      a, b = @differ.diff({ a: %w(bonjour allo) }, { a: %w(yellow molo) })
      assert_equal({ a: %w(bonjour allo) }, a)
      assert_equal({ a: %w(yellow molo) }, b)
    end

    def test_with_same_and_different_array_values
      a, b = @differ.diff({ a: %w(bonjour allo) }, { a: %w(bonjour yolo) })
      assert_equal({ a: [nil, "allo"] }, a)
      assert_equal({ a: [nil, "yolo"] }, b)
    end

    def test_different_array_values_size_on_b
      a, b = @differ.diff({ a: %w(bonjour allo) }, { a: %w(bonjour yolo henry) })
      assert_equal({ a: [nil, "allo", nil] }, a)
      assert_equal({ a: [nil, "yolo", "henry"] }, b)
    end

    def test_different_array_values_size_on_a
      a, b = @differ.diff({ a: %w(bonjour allo henry) }, { a: %w(bonjour yolo) })
      assert_equal({ a: [nil, "allo", "henry"] }, a)
      assert_equal({ a: [nil, "yolo", nil] }, b)
    end

    def test_with_same_nested_value
      a, b = @differ.diff({ a: { b: "bonjour" } }, { a: { b: "bonjour" } })
      assert_nil a
      assert_nil b
    end

    def test_with_different_nested_value
      a, b = @differ.diff({ a: { b: "bonjour" } }, { a: { b: "allo" } })
      assert_equal({ a: { b: "bonjour" } }, a)
      assert_equal({ a: { b: "allo" } }, b)
    end

    def test_with_same_and_different_nested_value
      a, b = @differ.diff({ a: { b: "bonjour", c: "yolo" } }, { a: { b: "allo", c: "yolo" } })
      assert_equal({ a: { b: "bonjour" } }, a)
      assert_equal({ a: { b: "allo" } }, b)
    end
  end
end
