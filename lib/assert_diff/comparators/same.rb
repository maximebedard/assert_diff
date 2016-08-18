module AssertDiff
  module Comparators
    class Same
      def call(a, b)
        a.equal?(b)
      end
    end
  end
end
