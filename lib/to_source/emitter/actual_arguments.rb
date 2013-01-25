module ToSource
  class Emitter
    # Emitter for arguments node
    class ActualArguments < self

      handle(Rubinius::AST::ActualArguments)

      # Test if any arguments are present
      #
      # @return [true]
      #   if any argument is present
      #
      # @return [false]
      #   otherwise
      #
      # @api private
      #
      def any?
        normal? || splat?
      end

    private

      # Perform dispatch
      #
      # @return [self]
      #
      # @api private
      #
      def dispatch
        emit_normal
        emit_splat
      end

      delegate :array, :splat

      # Test for splat argument
      #
      # @return [true]
      #   if splate argument is present
      #
      # @return [false]
      #   otherwise
      #
      # @api private
      #
      def splat?
        !!splat
      end

      # Test if normal arguments are present
      #
      # @return [true]
      #   if normal arguments are present
      #
      # @return [false]
      #   otherwise
      #
      # @api private
      #
      def normal?
        !array.empty?
      end

      # Emit normal arguments
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_normal
        run(Util::DelimitedBody, array)
      end

      # Emit splat argument
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_splat
        return unless splat?
        emit(', ') if normal?
        visit(splat) 
      end

    end
  end
end
