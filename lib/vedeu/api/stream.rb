module Vedeu
  module API
    class Stream < Vedeu::Stream
      include Helpers

      # Specify the alignment of the stream within the line. Useful in
      # combination with #width to provide simple formatting effects.
      #
      # @param value [Symbol] `:left`, `:centre` and `right` are valid values
      #   and will align accordingly. If not value is specified, the stream will
      #   left align.
      #
      # @return [Symbol]
      def align(value)
        attributes[:align] = value
      end

      # Add textual data to the stream via this method.
      #
      # @param value [String] The text to be added to the stream. If the length
      #   of the text is greater than the interface's width, it will be
      #   truncated and ellipsized.
      #
      # @return [String]
      def text(value)
        attributes[:text] = value
      end

      # Provides the ability to arbitrarily set the width of content for a
      # stream. Useful in combination with #align to provide simple formatting
      # effects.
      #
      # @param value [Fixnum] The width in characters.
      #
      # @return [Fixnum]
      def width(value)
        attributes[:width] = value
      end
    end
  end
end
