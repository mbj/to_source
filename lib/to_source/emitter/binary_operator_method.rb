module ToSource
  class Emitter
    class BinaryOperatorMethod < self

    private

      def dispatch
        emit('(')
        emit_left
        space
        emit(node.name)
        space
        emit_right
        emit(')')
      end

      def emit_right
        emit('(')
        visit(right)
        emit(')')
      end

      def emit_left
        emit('(')
        visit(left)
        emit(')')
      end

      def left
        node.receiver
      end

      def right
        node.arguments.array.first
      end

    end
  end
end
