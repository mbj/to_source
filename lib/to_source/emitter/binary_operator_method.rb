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
        parantheses do
          emit_left
          emit(" #{node.name} ")
          emit_right
        end
      end

      # Emit right
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_right
        parantheses do
          visit(right)
        end
      end

      # Emit left
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_left
        parantheses do
          visit(node.receiver)
        end
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
