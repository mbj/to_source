module ToSource
  class Emitter
    # Emitter for scoped cass module or constant names
    class ScopedName < self

      handle(Rubinius::AST::ScopedClassName)
      handle(Rubinius::AST::ScopedModuleName)
      handle(Rubinius::AST::ScopedConstant)

    private

      delegate(:parent, :name)

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        visit(parent)
        emit('::')
        emit(name)
      end

    end
  end
end
