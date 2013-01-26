module ToSource
  class Emitter

    class PushArgs < self

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        visit(node.arguments)
        emit(', ')
        visit(node.value)
      end

      class Array < self

        handle(Rubinius::AST::PushArgs)

      private

        # Perform dispatch
        #
        # @return [undefined]
        #
        # @api private
        #
        def dispatch
          emit('[')
          super
          emit(']')
        end
      end
    end
  end
end
