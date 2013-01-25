module ToSource
  class Emitter
    # Emitter for yield nodes
    class Yield < self

      handle(Rubinius::AST::Yield)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('yield')
        arguments = node.arguments
        unless arguments.array.empty?
          emit('(')
          visit(arguments)
          emit(')')
        end
      end

    end
  end
end
