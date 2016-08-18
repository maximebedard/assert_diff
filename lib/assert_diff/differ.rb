module AssertDiff
  class Differ
    def initialize(comparator: Comparators::Flexible.new, relation: Relation::Union)
      @comparator = comparator
      @relation = relation
    end

    def diff(a, b)
      return if comparator.call(a, b)

      if hashes?(a, b)
        diff_hash(a, b)
      elsif arrays?(a, b)
        diff_array(a, b)
      else
        [a, b]
      end
    end

    private

    attr_reader :comparator, :relation

    def hashes?(*args)
      args.all? { |elem| elem.is_a?(Hash) }
    end

    def arrays?(*args)
      args.all? { |elem| elem.is_a?(Array) }
    end

    def diff_hash(a, b)
      keys = relation.call(a.keys, b.keys)

      keys.each_with_object([{}, {}]) do |k, memo|
        next memo unless match = diff(a[k], b[k])

        memo[0][k], memo[1][k] = match
      end
    end

    def diff_array(a, b)
      padright(a, [a.size, b.size].max)
        .zip(b)
        .map { |args| diff(*args) || [nil, nil] }
        .transpose
    end

    def padright(a, n)
      a.dup.fill(nil, a.length...n)
    end
  end
end
