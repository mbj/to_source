module ToSource
  class Emitter

    # Base class for keyword with value emitters
    class KeywordValue < self

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit(self.class::SYMBOL)
        if value?
          emit('(')
          visit(node.value)
          emit(')')
        end
      end

      # Emitter for return nodes 
      class Return < self

        handle(Rubinius::AST::Return)
        SYMBOL = :return

      private
  
        # Perform dispatch
        #
        # @return [undefined]
        #
        # @api private
        #
        def value?
          !!node.value
        end
      end

      # Emitter for break nodes
      class Break < self

        handle(Rubinius::AST::Break)
        SYMBOL = :break

        # Test if value is present
        #
        # @return [true]
        #   if value is present
        #
        # @return [false]
        #   otherwise
        #
        # @api private
        #
        def value?
          !node.value.kind_of?(Rubinius::AST::NilLiteral)
        end

      end

    end
  end
end
