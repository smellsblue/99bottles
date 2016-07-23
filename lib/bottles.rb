module Pluralize
  refine String do
    def pluralize(n)
      if n == 1
        self
      else
        "#{self}s"
      end
    end
  end

  refine Integer do
    def pluralize(str)
      if zero?
        "no more #{str.pluralize(self)}"
      else
        "#{self} #{str.pluralize(self)}"
      end
    end
  end
end

module Target
  refine Integer do
    def target
      if self == 1
        "it"
      else
        "one"
      end
    end
  end
end

class Bottles
  using Pluralize
  using Target

  def verse(n)
    "#{n.pluralize("bottle")} of beer on the wall, #{n.pluralize("bottle")} of beer.\n" \
    "Take #{n.target} down and pass it around, #{(n - 1).pluralize("bottle")} of beer on the wall.\n"
  end
end
