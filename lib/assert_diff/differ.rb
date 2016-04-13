module AssertDiff
  class Differ
    class << self
      def diff(a, b, strict: true)
        return if compare(a, b)

        if a.is_a?(Hash) && b.is_a?(Hash)
          diff_hash(a, b, strict: strict)
        elsif a.is_a?(Array) && b.is_a?(Array)
          diff_array(a, b)
        else
          [a, b]
        end
      end

      private

      def compare(a, b)
        # byebug
        case b
        when Regexp
          a =~ b
        when Class, Symbol
          # byebug
          a.is_a?(b)
        else
          a == b
        end
      end

      def diff_hash(a, b, strict: true)
        keys = strict ? a.keys | b.keys : a.keys & b.keys

        keys.each_with_object([{}, {}]) do |k, memo|
          next memo unless match = diff(a[k], b[k], strict: strict)

          memo[0][k], memo[1][k] = match
        end
      end

      def diff_array(a, b, strict: true)
        padright(a, [a.size, b.size].max).zip(b).map do |args|
          diff(*args, strict: strict) || [nil, nil]
        end.transpose
      end

      def padright(a, n)
        a.dup.fill(nil, a.length...n)
      end
    end
  end
end
