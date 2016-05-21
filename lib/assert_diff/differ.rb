module AssertDiff
  class Differ
    def initialize(comparator: DefaultComparator.new, intersect: true)
      @comparator = comparator
      @intersect = intersect
    end

    def diff(a, b)
      return if comparator.compare(a, b)

      if a.is_a?(Hash) && b.is_a?(Hash)
        diff_hash(a, b)
      elsif a.is_a?(Array) && b.is_a?(Array)
        diff_array(a, b)
      else
        [a, b]
      end
    end

    private

    attr_reader :comparator, :intersect

    def diff_hash(a, b)
      keys = intersect ? a.keys | b.keys : a.keys & b.keys

      keys.each_with_object([{}, {}]) do |k, memo|
        next memo unless match = diff(a[k], b[k])

        memo[0][k], memo[1][k] = match
      end
    end

    def diff_array(a, b)
      padright(a, [a.size, b.size].max).zip(b).map do |args|
        diff(*args) || [nil, nil]
      end.transpose
    end

    def padright(a, n)
      a.dup.fill(nil, a.length...n)
    end
  end
end
