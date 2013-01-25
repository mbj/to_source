module ToSource
  class Emitter
    # Emitter for concat arguments
    class ConcatArguments < self

      handle(Rubinius::AST::ConcatArgs)

    private

      delegate(:rest)

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('[')
        run(Util::DelimitedBody, node.array.body)
        emit(', *')
        visit(rest)
        emit(']')
      end

    end
  end
end
