class Bottles
  module Capitalize
    refine String do
      def capitalize
        "#{self[0].upcase}#{self[1..size]}"
      end
    end
  end

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

  module Bottleable
    refine Integer do
      using Pluralize

      def to_bottles(suffix = nil)
        ["#{pluralize("bottle")} of beer", suffix].compact.join(" ")
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

  module Verseable
    refine Integer do
      def to_verse
        if zero?
          Bottles::LastVerse.new(self)
        else
          Bottles::Verse.new(self)
        end
      end
    end
  end

  using Bottleable
  using Capitalize
  using Pluralize
  using Target
  using Verseable

  class Verse
    attr_reader :n

    def initialize(n)
      @n = n
    end

    def to_s
      first_line + second_line
    end

    private

    def first_line
      "#{n.to_bottles("on the wall").capitalize}, #{n.to_bottles}.\n"
    end

    def second_line
      "Take #{n.target} down and pass it around, #{(n - 1).to_bottles("on the wall")}.\n"
    end
  end

  class LastVerse < Verse
    private

    def second_line
      "Go to the store and buy some more, #{99.to_bottles("on the wall")}.\n"
    end
  end

  def song
    verses(99, 0)
  end

  def verse(n)
    n.to_verse.to_s
  end

  def verses(start_n, end_n)
    start_n.downto(end_n).map { |n| n.to_verse }.join("\n")
  end
end
