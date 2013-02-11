module ToSource
  class Emitter
    # Emitter for binary operator methods
    class BinaryOperatorMethod < self

    private

      delegate(:arguments)
      predicate(:splat)

      # Return splat
      #
      # @return [Rubinius::AST::Node]
      #   if splat is present
      #
      # @return [nil]
      #   otherwise
      #
      # @api private
      #
      def splat
        arguments.splat
      end

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        parentheses do
          emit_left
          emit_operator
          emit_right
        end
      end

      # Emit operator
      #
      # @return [self]
      #
      # @api private
      #
      def emit_operator
        name = node.name
        if splat?
          emit(".#{name}")
        else
          emit(" #{name} ")
        end
      end

      # Emit right
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_right
        parentheses do
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
        parentheses do
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
        if splat?
          splat
        else
          arguments.array.first
        end
      end

    end
  end
end
