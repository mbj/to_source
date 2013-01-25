module ToSource
  class Emitter
    # Emitter for toplevel constants, classes and modules
    class Toplevel < self

      handle(Rubinius::AST::ToplevelClassName)
      handle(Rubinius::AST::ToplevelModuleName)
      handle(Rubinius::AST::ToplevelConstant)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        emit('::')
        emit(node.name)
      end

    end
  end
end
