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
        parantheses do
          emit_left
          emit(" #{self.class::SYMBOL} ")
          emit_right
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
          visit(node.left)
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
          visit(node.right)
        end
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
