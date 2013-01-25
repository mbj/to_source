module ToSource
  class Emitter
    # Emitter for class or modue scope names
    class ScopeName < self

      handle(Rubinius::AST::ClassName)
      handle(Rubinius::AST::ModuleName)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit(node.name)
      end

    end
  end
end
