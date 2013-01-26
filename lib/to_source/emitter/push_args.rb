module ToSource
  class Emitter

    class PushArgs < self

    private

      delegate(:arguments, :value)

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        visit(arguments)
        emit(', ')
        visit(value)
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
