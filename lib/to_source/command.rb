module ToSource
  # Abstract base class for emitter command
  class Command
    include Adamantium::Flat

    # A null command
    NULL = Class.new(self) do

      # Run command
      #
      # @param [State] _state
      #
      # @return [self]
      #
      # @api private
      #
      def run(_state)
        self
      end
    end.new.freeze

    # Command that emits token
    class Token < self
      attr_reader :content

      # Run command
      #
      # @param [State] state
      #
      # @return [self]
      #
      def run(state)
        state.push(self)
        self
      end

    private

      # Initialize object
      #
      # @param [String] content
      #
      # @return [undefined]
      #
      # @api private
      #
      def initialize(content)
        @content = content
      end

    end

    # Command that does a shift
    class Shift < self
      include Equalizer.new(:width)

      attr_reader :width

      # Run command
      #
      # @param [State]
      #
      # @return [self]
      #
      # @api private
      #
      def run(state)
        state.shift(width)
        self
      end

    private

      # Initialize command
      #
      # @param [Fixnum] with
      #
      # @return [undefined]
      #
      # @api private
      #
      def initialize(width)
        @width = width
      end

      INDENT   = Shift.new( 2)
      UNINDENT = Shift.new(-2)
    end

  end
end
