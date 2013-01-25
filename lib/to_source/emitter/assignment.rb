module ToSource
  class Emitter
    # Base class for various assignment nodes
    class Assignment < self
      include AbstractType

    private

      predicate(:value)

      # Return value to assign
      #
      # @return [Rubinius::AST::Node]
      #   if present
      #
      # @return [nil]
      #   otherwise
      #
      # @api private
      #
      abstract_method :value

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit_target
        if value?
          emit_operator
          emit_value
        end
      end

      # Emit value
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_value
        visit(value)
      end

      # Emit operator
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_operator
        emit(' = ')
      end
    end
  end
end
