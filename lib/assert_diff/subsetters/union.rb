module AssertDiff
  module Subsetters
    class Union
      def call(a, b)
        a | b
      end
    end
  end
end
