module ToSource
  class Emitter
    # Base class for binary operator emitters
    class BinaryOperator < self

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
        emit(self.class::SYMBOL)
        space
        emit_right
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
        visit(node.left)
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
        visit(node.right)
        emit(')')
      end

      # Emitter for binary or operator
      class Or < self

        handle(Rubinius::AST::Or)
        SYMBOL = :'||'

      end

      # Emitter for binary and operator
      class And < self

        handle(Rubinius::AST::And)
        SYMBOL = :'&&'

      end
    end
  end
end
