module ToSource
  class Emitter
    # Emitter for binary operator methods
    class BinaryOperatorMethod < self

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('(')
        emit_left
        space
        emit(node.name)
        space
        emit_right
        emit(')')
      end

      # Emit right
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_right
        emit('(')
        visit(right)
        emit(')')
      end

      # Emit left
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_left
        emit('(')
        visit(node.receiver)
        emit(')')
      end

      # Return right
      #
      # @return [Rubinius::AST::Node]
      #
      # @api private
      #
      def right
        node.arguments.array.first
      end

    end
  end
end
