module ToSource
  class Emitter
    class Yield < self

      handle(Rubinius::AST::Yield)

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
