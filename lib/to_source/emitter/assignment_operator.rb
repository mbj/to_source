module ToSource
  class Emitter

    # Base class for assignment operators
    class AssignmentOperator < self

    private

      delegate(:left, :right)

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        parantheses do
          visit(left)
          emit(" #{self.class::SYMBOL} ")
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
          visit(right.value)
        end
      end

      # Emitter for or assigmnent operator
      class Or < self

        handle(Rubinius::AST::OpAssignOr19)
        SYMBOL = :'||='

      end

      # Emitter for and assigmnent operator
      class And < self

        handle(Rubinius::AST::OpAssignAnd)
        SYMBOL = :'&&='

      end
    end
  end
end
