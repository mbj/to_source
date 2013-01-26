module ToSource
  class Emitter
    class Flip < self

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit_start
        emit(self.class::SYMBOL)
        emit_finish
      end

      # Emit start
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_start
        parantheses do
          # FIXME: Add reader
          visit(node.instance_variable_get(:@start))
        end
      end

      # Emit finish
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_finish
        parantheses do
          # FIXME: Add reader
          visit(node.instance_variable_get(:@finish))
        end
      end

      class Flip2 < self

        handle(Rubinius::AST::Flip2)
        SYMBOL = :'..'

      end

      class Flip3 < self

        handle(Rubinius::AST::Flip3)
        SYMBOL = :'...'

      end

    end
  end
end
