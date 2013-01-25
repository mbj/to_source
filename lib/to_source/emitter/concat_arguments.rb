module ToSource
  class Emitter
    # Emitter for concat arguments
    class ConcatArguments < self

      handle(Rubinius::AST::ConcatArgs)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('[')
        run(Util::DelimitedBody, node.array.body)
        emit(', ')
        emit('*')
        visit(node.rest)
        emit(']')
      end

    end
  end
end
