module AssertDiff
  module Subsetters
    class Intersection
      def call(a, b)
        a & b
      end
    end
  end
end
