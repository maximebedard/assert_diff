class DefaultComparator
  def compare(a, b)
    case b
    when Regexp
      a =~ b
    when Class, Symbol
      a.is_a?(b)
    else
      a == b
    end
  end
end
