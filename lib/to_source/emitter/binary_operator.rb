module ToSource
  class Emitter
    class BinaryOperator < self

    private

      def dispatch
        emit('(')
        emit_left
        space
        emit(self.class::SYMBOL)
        space
        emit_right
        emit(')')
      end

      def emit_left
        emit('(')
        visit(node.left)
        emit(')')
      end

      def emit_right
        emit('(')
        visit(node.right)
        emit(')')
      end

      class Or < self

        SYMBOL = :'||'

        handle(Rubinius::AST::Or)

      end

      class And < self

        SYMBOL = :'&&'

        handle(Rubinius::AST::And)

      end
    end
  end
end
