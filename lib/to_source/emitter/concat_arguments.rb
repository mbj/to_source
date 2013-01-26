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
        emit_array_body
        emit(', *')
        visit(rest)
        emit(']')
      end

      # Emit array body
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_array_body
        array = node.array
        case array
        when Rubinius::AST::ArrayLiteral
          run(Util::DelimitedBody, array.body)
        else
          visit(array)
        end
      end
    end
  end
end
