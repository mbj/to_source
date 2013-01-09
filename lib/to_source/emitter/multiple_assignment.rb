module ToSource
  class Emitter
    class MultipleAssignment < self

      handle(Rubinius::AST::MultipleAssignment)

    private

      def dispatch
        emit_left
        emit(' = ')
        emit_right
      end

      def emit_left
        run(Util::DelimitedBody, node.left.body)
      end

      def emit_right
        right = node.right
        if right.kind_of?(Rubinius::AST::ArrayLiteral)
          run(Util::DelimitedBody, right.body)
        else
          visit(right)
        end
      end

    end
  end
end
