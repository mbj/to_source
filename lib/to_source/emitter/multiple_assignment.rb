module ToSource
  class Emitter
    # Emitter for multiple assignment nodes
    class MultipleAssignment < self

      handle(Rubinius::AST::MultipleAssignment)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit_left
        emit(' = ')
        emit_right
      end

      # Emit left
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_left
        run(Util::DelimitedBody, node.left.body)
      end

      # Emit left
      #
      # @return [undefined]
      #
      # @api private
      #
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
